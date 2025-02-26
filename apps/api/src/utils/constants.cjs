// Order status events
const ORDER_EVENTS = {
    CREATED: 'created',
    ACCEPTED: 'accepted',
    IN_PROGRESS: 'in_progress',
    READY: 'ready',
    COMPLETED: 'completed',
    CANCELLED: 'cancelled',
    VERIFICATION_NEEDED: 'verification_needed',
    VERIFIED: 'verified'
};

// Pass events
const PASS_EVENTS = {
    PASS_CREATED: 'passCreated',
    PASS_VALIDATED: 'passValidated',
    PASS_USED: 'passUsed',
    PASS_EXPIRED: 'passExpired',
    PASS_UPDATED: 'passUpdated'
};

// Venue types
const VENUE_TYPES = [
    'Nightclub',
    'Bar',
    'Lounge',
    'Rooftop Lounge'
];

// Music types
const MUSIC_TYPES = [
    'Deep House',
    'Hip Hop',
    'Top 40',
    'Latin',
    'EDM',
    'Mixed'
];

// Pass types
const PASS_TYPES = [
    'drink',
    'skipline'
];

// Pass statuses
const PASS_STATUS = {
    ACTIVE: 'active',
    USED: 'used',
    EXPIRED: 'expired',
    CANCELLED: 'cancelled'
};

// Days of week
const DAYS_SHORT = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
const DAYS_FULL = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

// Schedule types
const SCHEDULE_TYPES = [
    'continuous',
    'dayOfWeek',
    'customDays'
];

// User roles
const USER_ROLES = {
    CUSTOMER: 'customer',
    OWNER: 'owner',
    ADMIN: 'admin'
};

// Order types
const ORDER_TYPES = [
    'drink',
    'pass'
];

// Error codes
const ERROR_CODES = {
    PASS_NOT_FOUND: 'PASS_NOT_FOUND',
    PASS_ALREADY_USED: 'PASS_ALREADY_USED',
    PASS_EXPIRED: 'PASS_EXPIRED',
    PASS_USE_ERROR: 'PASS_USE_ERROR',
    UNAUTHORIZED: 'UNAUTHORIZED',
    MISSING_REQUIRED_FIELD: 'MISSING_REQUIRED_FIELD'
};

// Payment status
const PAYMENT_STATUS = {
    PENDING: 'pending',
    COMPLETED: 'completed',
    FAILED: 'failed',
    REFUNDED: 'refunded'
};

// Service fee types
const SERVICE_FEE_TYPES = {
    FIXED: 'fixed',
    PERCENTAGE: 'percentage'
};

// Time formats
const TIME_FORMATS = {
    DISPLAY: 'h:mm A',      // 9:30 PM
    DATABASE: 'HH:mm',      // 21:30
    ISO: 'HH:mm:ss.SSSZ'   // 21:30:00.000Z
};

// Date formats
const DATE_FORMATS = {
    DISPLAY: 'MMM D, YYYY',         // Jan 1, 2024
    DATABASE: 'YYYY-MM-DD',         // 2024-01-01
    ISO: 'YYYY-MM-DDTHH:mm:ss.SSSZ' // 2024-01-01T00:00:00.000Z
};

// API rate limits (requests per minute)
const RATE_LIMITS = {
    AUTH: 300,      // Auth operations
    API: 500,       // General API
    PAYMENT: 100    // Payment operations
};

// Cache durations (in seconds)
const CACHE_DURATIONS = {
    MENU: 300,          // 5 minutes
    VENUE_INFO: 600,    // 10 minutes
    USER_INFO: 300,     // 5 minutes
    METRICS: 60         // 1 minute
};

// WebSocket events
const WS_EVENTS = {
    // Connection events
    CONNECT: 'connect',
    DISCONNECT: 'disconnect',
    RECONNECT: 'reconnect',
    ERROR: 'error',

    // Venue events
    JOIN_VENUE: 'joinVenue',
    LEAVE_VENUE: 'leaveVenue',
    VENUE_UPDATE: 'venueUpdate',

    // Pass events
    PASS_CREATED: 'passCreated',
    PASS_UPDATED: 'passUpdated',
    PASS_USED: 'passUsed',

    // Dashboard events
    DASHBOARD_UPDATE: 'dashboardUpdate',
    METRICS_UPDATE: 'metricsUpdate'
};

// Export all constants
module.exports = {
    ORDER_EVENTS,
    PASS_EVENTS,
    VENUE_TYPES,
    MUSIC_TYPES,
    PASS_TYPES,
    PASS_STATUS,
    DAYS_SHORT,
    DAYS_FULL,
    SCHEDULE_TYPES,
    USER_ROLES,
    ORDER_TYPES,
    ERROR_CODES,
    SERVICE_FEE_TYPES,
    TIME_FORMATS,
    DATE_FORMATS,
    RATE_LIMITS,
    CACHE_DURATIONS,
    WS_EVENTS
}; 