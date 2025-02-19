# FOMO API Contract

## Overview
This document outlines the API contract for the FOMO iOS application. All endpoints use JSON for request and response bodies.

## Base URL
- Development: `https://api.dev.fomo.com/v1`
- Production: `https://api.fomo.com/v1`

## Authentication
All requests require a Bearer token in the Authorization header:
```
Authorization: Bearer <token>
```

## Endpoints

### Venues

#### GET /venues
Retrieves a list of all venues.

**Response**
```json
{
  "venues": [
    {
      "id": "string",
      "name": "string",
      "description": "string",
      "address": "string",
      "imageUrl": "string",
      "capacity": "integer",
      "currentCapacity": "integer",
      "rating": "double",
      "isOpen": "boolean",
      "waitTime": "integer"
    }
  ]
}
```

#### GET /venues/{id}
Retrieves details for a specific venue.

**Parameters**
- `id`: Venue identifier

**Response**
```json
{
  "id": "string",
  "name": "string",
  "description": "string",
  "address": "string",
  "imageUrl": "string",
  "capacity": "integer",
  "currentCapacity": "integer",
  "rating": "double",
  "isOpen": "boolean",
  "waitTime": "integer",
  "pricingTiers": [
    {
      "id": "string",
      "name": "string",
      "description": "string",
      "price": "decimal",
      "features": ["string"],
      "maxCapacity": "integer?"
    }
  ]
}
```

### Passes

#### GET /passes
Retrieves all passes for the authenticated user.

**Response**
```json
{
  "passes": [
    {
      "id": "string",
      "venueId": "string",
      "userId": "string",
      "type": "string",
      "purchaseDate": "ISO8601 date",
      "expirationDate": "ISO8601 date",
      "status": "string"
    }
  ]
}
```

#### POST /passes/purchase
Purchases a new pass.

**Request**
```json
{
  "venue_id": "string",
  "tier_id": "string"
}
```

**Response**
```json
{
  "id": "string",
  "venueId": "string",
  "userId": "string",
  "type": "string",
  "purchaseDate": "ISO8601 date",
  "expirationDate": "ISO8601 date",
  "status": "string"
}
```

### Profile

#### GET /profile
Retrieves the authenticated user's profile.

**Response**
```json
{
  "id": "string",
  "username": "string",
  "email": "string",
  "firstName": "string",
  "lastName": "string",
  "membershipLevel": "string",
  "preferences": {
    "notificationsEnabled": "boolean",
    "emailUpdatesEnabled": "boolean",
    "favoriteVenueIds": ["string"],
    "preferredVenueTypes": ["string"],
    "dietaryRestrictions": ["string"]
  },
  "paymentMethods": [
    {
      "id": "string",
      "lastFourDigits": "string",
      "type": "string"
    }
  ]
}
```

#### PUT /profile/update
Updates the authenticated user's profile.

**Request**
Same schema as GET /profile response

**Response**
Same schema as GET /profile response

### Drinks

#### GET /venues/{venueId}/drinks
Retrieves the drink menu for a specific venue.

**Parameters**
- `venueId`: Venue identifier

**Response**
```json
{
  "drinks": [
    {
      "id": "string",
      "name": "string",
      "description": "string",
      "price": "decimal",
      "category": "string",
      "imageUrl": "string",
      "available": "boolean"
    }
  ],
  "categories": ["string"]
}
```

#### POST /orders
Places a drink order.

**Request**
```json
{
  "id": "string",
  "items": [
    {
      "id": "string",
      "drinkId": "string",
      "quantity": "integer"
    }
  ]
}
```

**Response**
```json
{
  "id": "string",
  "status": "string",
  "total": "decimal",
  "estimatedWaitTime": "integer",
  "items": [
    {
      "id": "string",
      "drinkId": "string",
      "quantity": "integer",
      "subtotal": "decimal"
    }
  ]
}
```

## Error Responses
All endpoints may return the following error responses:

```json
{
  "error": {
    "code": "string",
    "message": "string"
  }
}
```

Common error codes:
- `unauthorized`: Invalid or missing authentication
- `forbidden`: Insufficient permissions
- `not_found`: Requested resource not found
- `validation_error`: Invalid request parameters
- `server_error`: Internal server error 