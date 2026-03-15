"""
Agora Database Application
Connects to MySQL and demonstrates SELECT, INSERT, UPDATE, DELETE
using prepared statements. Also executes one transaction programmatically.

Requirements:
    pip install mysql-connector-python

Usage:
    python app.py

Set the DB_* constants below to match your MySQL connection.
"""

import mysql.connector
from mysql.connector import Error

DB_HOST = "localhost"
DB_PORT = 3306
DB_NAME = "agora_db"
DB_USER = "root"
DB_PASS = ""


def connect():
    return mysql.connector.connect(
        host=DB_HOST,
        port=DB_PORT,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASS
    )


def print_rows(cursor, label):
    rows = cursor.fetchall()
    cols = [d[0] for d in cursor.description]
    print(f"\n--- {label} ---")
    print("  " + " | ".join(cols))
    print("  " + "-" * 60)
    for row in rows:
        print("  " + " | ".join(str(v) for v in row))
    print(f"  ({len(rows)} row(s))")


# ------------------------------------------------------------------
# SELECT: top 5 users by reputation score
# ------------------------------------------------------------------
def select_top_users(conn):
    cursor = conn.cursor()
    sql = """
        SELECT user_id, name, reputation_score
        FROM User
        ORDER BY reputation_score DESC
        LIMIT %s
    """
    cursor.execute(sql, (5,))
    print_rows(cursor, "Top 5 Users by Reputation")
    cursor.close()


# ------------------------------------------------------------------
# SELECT: all problems for a given course with answer counts
# ------------------------------------------------------------------
def select_problems_for_course(conn, course_id):
    cursor = conn.cursor()
    sql = """
        SELECT pr.problem_id,
               pr.title,
               COUNT(a.answer_id) AS answer_count,
               MAX(a.is_accepted) AS has_accepted
        FROM Problem pr
        LEFT JOIN Answer a ON pr.problem_id = a.problem_id
        WHERE pr.course_id = %s
        GROUP BY pr.problem_id, pr.title
        ORDER BY pr.created_at DESC
    """
    cursor.execute(sql, (course_id,))
    print_rows(cursor, f"Problems for course_id={course_id}")
    cursor.close()


# ------------------------------------------------------------------
# INSERT: add a new user
# ------------------------------------------------------------------
def insert_user(conn, email, name, university):
    cursor = conn.cursor()
    sql = """
        INSERT INTO User (email, name, university, reputation_score)
        VALUES (%s, %s, %s, %s)
    """
    cursor.execute(sql, (email, name, university, 0))
    conn.commit()
    new_id = cursor.lastrowid
    print(f"\n--- INSERT User ---")
    print(f"  Inserted user_id={new_id}: {name} ({email})")
    cursor.close()
    return new_id


# ------------------------------------------------------------------
# UPDATE: increment a user's reputation score
# ------------------------------------------------------------------
def update_reputation(conn, user_id, points):
    cursor = conn.cursor()
    sql = """
        UPDATE User
        SET reputation_score = reputation_score + %s
        WHERE user_id = %s
    """
    cursor.execute(sql, (points, user_id))
    conn.commit()
    print(f"\n--- UPDATE Reputation ---")
    print(f"  Added {points} points to user_id={user_id} ({cursor.rowcount} row affected)")
    cursor.close()


# ------------------------------------------------------------------
# DELETE: remove a user by user_id
# ------------------------------------------------------------------
def delete_user(conn, user_id):
    cursor = conn.cursor()
    sql = "DELETE FROM User WHERE user_id = %s"
    cursor.execute(sql, (user_id,))
    conn.commit()
    print(f"\n--- DELETE User ---")
    print(f"  Deleted user_id={user_id} ({cursor.rowcount} row affected)")
    cursor.close()


# ------------------------------------------------------------------
# TRANSACTION: enroll a user in a course atomically
# Inserts the enrollment and logs a summary; rolls back on error.
# ------------------------------------------------------------------
def enroll_user(conn, user_id, course_id):
    cursor = conn.cursor()
    try:
        conn.start_transaction()

        # Check the course exists
        cursor.execute(
            "SELECT name FROM Course WHERE course_id = %s",
            (course_id,)
        )
        course = cursor.fetchone()
        if not course:
            raise ValueError(f"course_id={course_id} does not exist")

        # Insert enrollment
        cursor.execute(
            "INSERT INTO Enrollment (user_id, course_id) VALUES (%s, %s)",
            (user_id, course_id)
        )

        conn.commit()
        print(f"\n--- TRANSACTION: Enroll User ---")
        print(f"  user_id={user_id} enrolled in '{course[0]}' (course_id={course_id})")

    except Error as e:
        conn.rollback()
        print(f"\n--- TRANSACTION ROLLED BACK ---")
        print(f"  Reason: {e}")
    finally:
        cursor.close()


# ------------------------------------------------------------------
# Main
# ------------------------------------------------------------------
def main():
    try:
        conn = connect()
        print(f"Connected to {DB_NAME} on {DB_HOST}")

        select_top_users(conn)
        select_problems_for_course(conn, course_id=2)

        new_user_id = insert_user(
            conn,
            email="demo.student@stcloudstate.edu",
            name="Demo Student",
            university="Saint Cloud State University"
        )

        update_reputation(conn, user_id=new_user_id, points=25)

        # Enroll the new user in Database Systems (course_id = 2)
        enroll_user(conn, user_id=new_user_id, course_id=2)

        # Attempt a duplicate enrollment to show rollback behavior
        enroll_user(conn, user_id=new_user_id, course_id=2)

        delete_user(conn, user_id=new_user_id)

        conn.close()
        print("\nDone.")

    except Error as e:
        print(f"Connection error: {e}")


if __name__ == "__main__":
    main()
