// Agora NoSQL Component — MongoDB
// Collection: activity_logs
// Mirrors user activity that does not need relational structure:
// page views, upvote events, and search queries.
// Run these commands in the MongoDB shell or mongosh.

use agora_nosql;

// -----------------------------------------------------------------------
// Collection: activity_logs
// Each document records one user action with flexible metadata.
// -----------------------------------------------------------------------

// Insert — page view events
db.activity_logs.insertMany([
  {
    user_id: 1,
    event: "page_view",
    target: "course_feed",
    course_id: 2,
    timestamp: ISODate("2025-09-10T09:00:00Z"),
    metadata: { device: "desktop", duration_sec: 120 }
  },
  {
    user_id: 2,
    event: "page_view",
    target: "problem_detail",
    problem_id: 1,
    timestamp: ISODate("2025-09-11T09:05:00Z"),
    metadata: { device: "mobile", duration_sec: 45 }
  },
  {
    user_id: 3,
    event: "page_view",
    target: "course_feed",
    course_id: 2,
    timestamp: ISODate("2025-09-12T08:30:00Z"),
    metadata: { device: "desktop", duration_sec: 200 }
  },
  {
    user_id: 5,
    event: "page_view",
    target: "user_profile",
    profile_user_id: 1,
    timestamp: ISODate("2025-09-13T14:10:00Z"),
    metadata: { device: "desktop", duration_sec: 30 }
  },
  {
    user_id: 7,
    event: "page_view",
    target: "resource_list",
    course_id: 2,
    timestamp: ISODate("2025-09-14T10:00:00Z"),
    metadata: { device: "tablet", duration_sec: 90 }
  }
]);

// Insert — upvote events
db.activity_logs.insertMany([
  {
    user_id: 4,
    event: "upvote",
    target: "post",
    target_id: 7,
    timestamp: ISODate("2025-09-15T10:30:00Z"),
    metadata: {}
  },
  {
    user_id: 6,
    event: "upvote",
    target: "answer",
    target_id: 1,
    timestamp: ISODate("2025-09-11T11:30:00Z"),
    metadata: {}
  },
  {
    user_id: 9,
    event: "upvote",
    target: "problem",
    target_id: 8,
    timestamp: ISODate("2025-09-16T09:30:00Z"),
    metadata: {}
  },
  {
    user_id: 11,
    event: "upvote",
    target: "post",
    target_id: 3,
    timestamp: ISODate("2025-09-12T09:00:00Z"),
    metadata: {}
  },
  {
    user_id: 13,
    event: "upvote",
    target: "answer",
    target_id: 12,
    timestamp: ISODate("2025-09-16T11:00:00Z"),
    metadata: {}
  }
]);

// Insert — search events
db.activity_logs.insertMany([
  {
    user_id: 2,
    event: "search",
    query: "normalization 3NF",
    results_count: 4,
    timestamp: ISODate("2025-09-11T09:00:00Z"),
    metadata: { course_filter: 2 }
  },
  {
    user_id: 8,
    event: "search",
    query: "quicksort pivot",
    results_count: 2,
    timestamp: ISODate("2025-09-12T10:00:00Z"),
    metadata: { course_filter: 1 }
  },
  {
    user_id: 14,
    event: "search",
    query: "trig substitution",
    results_count: 3,
    timestamp: ISODate("2025-09-14T14:00:00Z"),
    metadata: { course_filter: 5 }
  },
  {
    user_id: 17,
    event: "search",
    query: "composite index mysql",
    results_count: 5,
    timestamp: ISODate("2025-09-25T10:00:00Z"),
    metadata: { course_filter: 2 }
  },
  {
    user_id: 20,
    event: "search",
    query: "improper integral diverge",
    results_count: 2,
    timestamp: ISODate("2025-09-26T09:00:00Z"),
    metadata: { course_filter: 5 }
  }
]);


// -----------------------------------------------------------------------
// Queries
// -----------------------------------------------------------------------

// Find all activity logs for user 2
db.activity_logs.find({ user_id: 2 });

// Find all upvote events
db.activity_logs.find({ event: "upvote" });

// Find all page_view events on course_feed pages
db.activity_logs.find({ event: "page_view", target: "course_feed" });

// Find all search events with more than 3 results
db.activity_logs.find({ event: "search", results_count: { $gt: 3 } });

// Find all events after September 15, 2025
db.activity_logs.find({
  timestamp: { $gt: ISODate("2025-09-15T00:00:00Z") }
});

// Count events grouped by event type
db.activity_logs.aggregate([
  { $group: { _id: "$event", count: { $sum: 1 } } },
  { $sort: { count: -1 } }
]);

// Most active users by number of logged events
db.activity_logs.aggregate([
  { $group: { _id: "$user_id", total_events: { $sum: 1 } } },
  { $sort: { total_events: -1 } },
  { $limit: 5 }
]);

// Top search queries
db.activity_logs.aggregate([
  { $match: { event: "search" } },
  { $group: { _id: "$query", count: { $sum: 1 } } },
  { $sort: { count: -1 } }
]);

// Create an index on user_id and timestamp for fast per-user activity lookups
db.activity_logs.createIndex({ user_id: 1, timestamp: -1 });
