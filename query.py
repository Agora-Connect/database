"""
Simple Database Query Script
Modify the query variable below to run any SQL query
"""

import sqlite3
from pathlib import Path

# Get the directory where this script is located
SCRIPT_DIR = Path(__file__).parent
DB_PATH = SCRIPT_DIR / "agora.db"

# Connect to database
conn = sqlite3.connect(DB_PATH)
cursor = conn.cursor()

# ============================================
# WRITE YOUR QUERY HERE
# ============================================

query = """
INSERT INTO user (email, name, university, reputation_score, created_at) 
VALUES ('test@gmail.com', 'Test User', 'Saint Cloud State University', 0, datetime('now'))
"""
# ============================================
# Execute and display results
# ============================================

try:
    cursor.execute(query)
    
    # Check if this is a SELECT query (returns data)
    if query.strip().upper().startswith('SELECT') or query.strip().upper().startswith('PRAGMA'):
        rows = cursor.fetchall()
        
        # Get column names
        column_names = [description[0] for description in cursor.description]
        
        print("\n" + "="*80)
        print(f"QUERY: {query.strip()}")
        print("="*80)
        print(f"\nFound {len(rows)} rows\n")
        
        # Print column headers
        print(" | ".join(column_names))
        print("-" * 80)
        
        # Print rows
        for row in rows:
            print(" | ".join(str(value) for value in row))
        
        print("\n")
    
    else:
        # This is an INSERT, UPDATE, DELETE, or other modifying query
        conn.commit()
        print("\n" + "="*80)
        print(f"QUERY: {query.strip()}")
        print("="*80)
        print(f"\n✓ Success! {cursor.rowcount} row(s) affected\n")
    
except sqlite3.Error as e:
    print(f"\n✗ Error: {e}\n")
    conn.rollback()

finally:
    conn.close()


# ============================================
# EXAMPLE QUERIES (copy & paste above)
# ============================================

# Get all users
# query = "SELECT * FROM user"

# Get all courses
# query = "SELECT * FROM course"

# INSERT a new user (with all fields to avoid None values)
# query = """
# INSERT INTO user (email, name, university, reputation_score, created_at)
# VALUES ('alice.brown@university.edu', 'Alice Brown', 'University of Example', 0, datetime('now'))
# """

# INSERT a new course
# query = """
# INSERT INTO course (code, name, description)
# VALUES ('ENGL 101', 'English Composition', 'Introduction to academic writing')
# """

# UPDATE user reputation
# query = """
# UPDATE user 
# SET reputation_score = 100 
# WHERE email = 'john.doe@university.edu'
# """

# DELETE a user (be careful!)
# query = """
# DELETE FROM user 
# WHERE email = 'test@university.edu'
# """

# Get enrollments with user names
# query = """
# SELECT u.name, c.code, c.name 
# FROM enrollment e
# JOIN user u ON e.user_id = u.user_id
# JOIN course c ON e.course_id = c.course_id
# """

# Count users per university
# query = """
# SELECT university, COUNT(*) as user_count
# FROM user
# GROUP BY university
# """

# Get user with highest reputation
# query = """
# SELECT name, email, reputation_score
# FROM user
# ORDER BY reputation_score DESC
# LIMIT 5
# """

# List all tables in database
# query = """
# SELECT name FROM sqlite_master 
# WHERE type='table'
# ORDER BY name
# """

# Get table structure
# query = "PRAGMA table_info(user)"

# Get all tags
# query = "SELECT * FROM tag"
