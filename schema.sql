-- Agora Academic Collaboration Platform
-- MySQL Schema
-- Database: agora_db

DROP DATABASE IF EXISTS agora_db;
CREATE DATABASE agora_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE agora_db;

-- Verified university students
CREATE TABLE User (
    user_id          INT          NOT NULL AUTO_INCREMENT,
    email            VARCHAR(255) NOT NULL,
    name             VARCHAR(255) NOT NULL,
    university       VARCHAR(255) NOT NULL DEFAULT 'Saint Cloud State University',
    reputation_score INT          NOT NULL DEFAULT 0,
    created_at       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_user        PRIMARY KEY (user_id),
    CONSTRAINT uq_user_email  UNIQUE      (email),
    CONSTRAINT chk_user_rep   CHECK       (reputation_score >= 0),
    CONSTRAINT chk_user_email CHECK       (email LIKE '%@%.%')
);

-- University courses (e.g., CSCI 411, MATH 221)
CREATE TABLE Course (
    course_id   INT          NOT NULL AUTO_INCREMENT,
    code        VARCHAR(50)  NOT NULL,
    name        VARCHAR(255) NOT NULL,
    description TEXT,
    created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_course      PRIMARY KEY (course_id),
    CONSTRAINT uq_course_code UNIQUE      (code)
);

-- Weak entity: ties a user to a course; no meaning without both
CREATE TABLE Enrollment (
    enrollment_id INT       NOT NULL AUTO_INCREMENT,
    user_id       INT       NOT NULL,
    course_id     INT       NOT NULL,
    enrolled_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_enrollment             PRIMARY KEY (enrollment_id),
    CONSTRAINT uq_enrollment_user_course UNIQUE      (user_id, course_id),
    CONSTRAINT fk_enrollment_user        FOREIGN KEY (user_id)
        REFERENCES User(user_id)   ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_enrollment_course      FOREIGN KEY (course_id)
        REFERENCES Course(course_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Reusable labels applied to posts and problems
CREATE TABLE Tag (
    tag_id INT          NOT NULL AUTO_INCREMENT,
    name   VARCHAR(100) NOT NULL,

    CONSTRAINT pk_tag      PRIMARY KEY (tag_id),
    CONSTRAINT uq_tag_name UNIQUE      (name)
);

-- General educational posts scoped to a course
CREATE TABLE Post (
    post_id      INT       NOT NULL AUTO_INCREMENT,
    user_id      INT       NOT NULL,
    course_id    INT       NOT NULL,
    content      TEXT      NOT NULL,
    is_anonymous BOOLEAN   NOT NULL DEFAULT FALSE,
    created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_post        PRIMARY KEY (post_id),
    CONSTRAINT fk_post_user   FOREIGN KEY (user_id)
        REFERENCES User(user_id)     ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_post_course FOREIGN KEY (course_id)
        REFERENCES Course(course_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Academic questions posted in the Q&A forum
CREATE TABLE Problem (
    problem_id  INT          NOT NULL AUTO_INCREMENT,
    user_id     INT          NOT NULL,
    course_id   INT          NOT NULL,
    title       VARCHAR(255) NOT NULL,
    description TEXT         NOT NULL,
    created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_problem        PRIMARY KEY (problem_id),
    CONSTRAINT fk_problem_user   FOREIGN KEY (user_id)
        REFERENCES User(user_id)     ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_problem_course FOREIGN KEY (course_id)
        REFERENCES Course(course_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Student responses to problems
-- Business rules: one answer per user per problem; one accepted answer per problem (enforced by trigger)
CREATE TABLE Answer (
    answer_id   INT       NOT NULL AUTO_INCREMENT,
    problem_id  INT       NOT NULL,
    user_id     INT       NOT NULL,
    content     TEXT      NOT NULL,
    is_accepted BOOLEAN   NOT NULL DEFAULT FALSE,
    created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_answer              PRIMARY KEY (answer_id),
    CONSTRAINT uq_answer_user_problem UNIQUE      (problem_id, user_id),
    CONSTRAINT fk_answer_problem      FOREIGN KEY (problem_id)
        REFERENCES Problem(problem_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_answer_user         FOREIGN KEY (user_id)
        REFERENCES User(user_id)       ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Trigger: prevents more than one accepted answer per problem
DELIMITER $$
CREATE TRIGGER trg_one_accepted_answer
BEFORE UPDATE ON Answer
FOR EACH ROW
BEGIN
    IF NEW.is_accepted = TRUE AND OLD.is_accepted = FALSE THEN
        IF EXISTS (
            SELECT 1 FROM Answer
            WHERE problem_id = NEW.problem_id
              AND is_accepted = TRUE
              AND answer_id  != NEW.answer_id
        ) THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'A problem can only have one accepted answer.';
        END IF;
    END IF;
END$$
DELIMITER ;

-- Comments on posts
CREATE TABLE CommentOnPost (
    comment_id INT       NOT NULL AUTO_INCREMENT,
    post_id    INT       NOT NULL,
    user_id    INT       NOT NULL,
    content    TEXT      NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_comment_post      PRIMARY KEY (comment_id),
    CONSTRAINT fk_comment_post_post FOREIGN KEY (post_id)
        REFERENCES Post(post_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_comment_post_user FOREIGN KEY (user_id)
        REFERENCES User(user_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Comments on problems
CREATE TABLE CommentOnProblem (
    comment_id INT       NOT NULL AUTO_INCREMENT,
    problem_id INT       NOT NULL,
    user_id    INT       NOT NULL,
    content    TEXT      NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_comment_problem         PRIMARY KEY (comment_id),
    CONSTRAINT fk_comment_problem_problem FOREIGN KEY (problem_id)
        REFERENCES Problem(problem_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_comment_problem_user    FOREIGN KEY (user_id)
        REFERENCES User(user_id)        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Comments on answers
CREATE TABLE CommentOnAnswer (
    comment_id INT       NOT NULL AUTO_INCREMENT,
    answer_id  INT       NOT NULL,
    user_id    INT       NOT NULL,
    content    TEXT      NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_comment_answer         PRIMARY KEY (comment_id),
    CONSTRAINT fk_comment_answer_answer  FOREIGN KEY (answer_id)
        REFERENCES Answer(answer_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_comment_answer_user    FOREIGN KEY (user_id)
        REFERENCES User(user_id)     ON DELETE RESTRICT ON UPDATE CASCADE
);

-- One upvote per user per post
CREATE TABLE UpvoteOnPost (
    upvote_id  INT       NOT NULL AUTO_INCREMENT,
    post_id    INT       NOT NULL,
    user_id    INT       NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_upvote_post      PRIMARY KEY (upvote_id),
    CONSTRAINT uq_upvote_post      UNIQUE      (post_id, user_id),
    CONSTRAINT fk_upvote_post_post FOREIGN KEY (post_id)
        REFERENCES Post(post_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_upvote_post_user FOREIGN KEY (user_id)
        REFERENCES User(user_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- One upvote per user per problem
CREATE TABLE UpvoteOnProblem (
    upvote_id  INT       NOT NULL AUTO_INCREMENT,
    problem_id INT       NOT NULL,
    user_id    INT       NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_upvote_problem      PRIMARY KEY (upvote_id),
    CONSTRAINT uq_upvote_problem      UNIQUE      (problem_id, user_id),
    CONSTRAINT fk_upvote_problem_prob FOREIGN KEY (problem_id)
        REFERENCES Problem(problem_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_upvote_problem_user FOREIGN KEY (user_id)
        REFERENCES User(user_id)       ON DELETE CASCADE ON UPDATE CASCADE
);

-- One upvote per user per answer
CREATE TABLE UpvoteOnAnswer (
    upvote_id  INT       NOT NULL AUTO_INCREMENT,
    answer_id  INT       NOT NULL,
    user_id    INT       NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_upvote_answer         PRIMARY KEY (upvote_id),
    CONSTRAINT uq_upvote_answer         UNIQUE      (answer_id, user_id),
    CONSTRAINT fk_upvote_answer_answer  FOREIGN KEY (answer_id)
        REFERENCES Answer(answer_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_upvote_answer_user    FOREIGN KEY (user_id)
        REFERENCES User(user_id)     ON DELETE CASCADE ON UPDATE CASCADE
);

-- Self-referential social graph; a user cannot follow themselves
CREATE TABLE Follow (
    follow_id   INT       NOT NULL AUTO_INCREMENT,
    follower_id INT       NOT NULL,
    followed_id INT       NOT NULL,
    created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_follow          PRIMARY KEY (follow_id),
    CONSTRAINT uq_follow_pair     UNIQUE      (follower_id, followed_id),
    CONSTRAINT chk_follow_no_self CHECK       (follower_id != followed_id),
    CONSTRAINT fk_follow_follower FOREIGN KEY (follower_id)
        REFERENCES User(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_follow_followed FOREIGN KEY (followed_id)
        REFERENCES User(user_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Shared academic materials; assignment and syllabus sharing not permitted
CREATE TABLE Resource (
    resource_id INT          NOT NULL AUTO_INCREMENT,
    user_id     INT          NOT NULL,
    course_id   INT          NOT NULL,
    title       VARCHAR(255) NOT NULL,
    type        VARCHAR(50)  NOT NULL,
    file_path   VARCHAR(500),
    created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_resource        PRIMARY KEY (resource_id),
    CONSTRAINT chk_resource_type  CHECK       (type IN ('textbook', 'notes', 'study_guide', 'past_exam', 'other')),
    CONSTRAINT fk_resource_user   FOREIGN KEY (user_id)
        REFERENCES User(user_id)     ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_resource_course FOREIGN KEY (course_id)
        REFERENCES Course(course_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Weak entity: borrow/lend lifecycle for a resource; deleted when resource is deleted
CREATE TABLE BorrowRequest (
    request_id   INT         NOT NULL AUTO_INCREMENT,
    resource_id  INT         NOT NULL,
    requester_id INT         NOT NULL,
    owner_id     INT         NOT NULL,
    status       VARCHAR(20) NOT NULL DEFAULT 'pending',
    requested_at TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at   TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT pk_borrow_request   PRIMARY KEY (request_id),
    CONSTRAINT chk_borrow_status   CHECK       (status IN ('pending', 'approved', 'returned', 'declined')),
    CONSTRAINT chk_borrow_no_self  CHECK       (requester_id != owner_id),
    CONSTRAINT fk_borrow_resource  FOREIGN KEY (resource_id)
        REFERENCES Resource(resource_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_borrow_requester FOREIGN KEY (requester_id)
        REFERENCES User(user_id)         ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_borrow_owner     FOREIGN KEY (owner_id)
        REFERENCES User(user_id)         ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Many-to-many: posts and tags
CREATE TABLE PostTag (
    post_id INT NOT NULL,
    tag_id  INT NOT NULL,

    CONSTRAINT pk_post_tag      PRIMARY KEY (post_id, tag_id),
    CONSTRAINT fk_post_tag_post FOREIGN KEY (post_id)
        REFERENCES Post(post_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_post_tag_tag  FOREIGN KEY (tag_id)
        REFERENCES Tag(tag_id)   ON DELETE CASCADE ON UPDATE CASCADE
);

-- Many-to-many: problems and tags
CREATE TABLE ProblemTag (
    problem_id INT NOT NULL,
    tag_id     INT NOT NULL,

    CONSTRAINT pk_problem_tag         PRIMARY KEY (problem_id, tag_id),
    CONSTRAINT fk_problem_tag_problem FOREIGN KEY (problem_id)
        REFERENCES Problem(problem_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_problem_tag_tag     FOREIGN KEY (tag_id)
        REFERENCES Tag(tag_id)         ON DELETE CASCADE ON UPDATE CASCADE
);
