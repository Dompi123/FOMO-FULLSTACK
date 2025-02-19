Querying Perplexity AI using sonar-pro for: Validate API contracts for FOMO app
API contract testing for the FOMO app should focus on validating:

1. Request/response structure matches the defined schema:
- Validate fields, data types, required vs optional parameters
- Example: GET /events should return an array of event objects with id, type, timestamp fields

2. Authentication and authorization:
- Validate API key/token requirements
- Check access controls for different endpoints

3. Rate limiting and quotas:
- Verify rate limit headers are present
- Test behavior when limits are exceeded

4. Error handling:
- Validate error response formats
- Test common error scenarios (invalid input, not found, etc.)

5. Versioning:
- Ensure API version is specified in requests
- Validate behavior for deprecated versions

6. Webhooks:
- Verify webhook payload structure 
- Test webhook delivery and retry logic

Example test in Postman:

```javascript
pm.test("Response schema is valid", function() {
  var schema = {
    "type": "object",
    "properties": {
      "id": {"type": "string"},
      "event_type": {"type": "string"},
      "timestamp": {"type": "number"}
    },
    "required": ["id", "event_type", "timestamp"]
  };
  
  pm.expect(tv4.validate(pm.response.json(), schema)).to.be.true;
});
```

This validates the response matches the expected schema for an event object.