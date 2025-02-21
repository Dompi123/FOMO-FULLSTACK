# FOMO Backend Integration Guide

## API Version: v1

### Required Headers
| Header | Description | Example |
|--------|-------------|---------|
| Authorization | Bearer token for authentication | `Bearer eyJ0...` |
| X-Device-ID | Unique device identifier | `XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX` |
| X-Client-Version | App version number | `1.0.0` |
| Content-Type | API content type | `application/json` |

### Error Code Mapping
| Backend Code | Client Error | Description |
|--------------|--------------|-------------|
| rate_limit_exceeded | .rateLimitExceeded | Too many requests |
| insufficient_funds | .insufficientFunds | Payment card has insufficient funds |
| invalid_card | .invalidCard | Invalid card details |
| expired_card | .expiredCard | Card has expired |
| card_declined | .cardDeclined | Card was declined |
| processing_error | .processingError | Payment processing failed |

### Retry Strategy
- Maximum 3 retry attempts
- Exponential backoff: delay = baseDelay * pow(retryDelay, attemptNumber)
- Only retry on rate limits and temporary network issues
- Do not retry on authentication or validation errors

### Health Check
- Endpoint: `/v1/health`
- Method: GET
- Response: `{ "status": "operational" | "degraded" | "down" }`
- No authentication required

### Security Requirements
- All requests must use HTTPS
- API keys must be stored in Keychain
- Device IDs must be unique per installation
- Tokens must be rotated on version updates

### Integration Testing
1. Run the test suite: `xcodebuild test -scheme FOMO_PRODUCTION`
2. Verify backend logs for successful requests
3. Check CI pipeline status
4. Validate error handling with test cases

### Validation Checklist
- [ ] All required headers present
- [ ] Error mapping complete
- [ ] Retry logic implemented
- [ ] Health check operational
- [ ] Security audit passed
- [ ] Integration tests passing

### Troubleshooting
1. Check network monitor logs
2. Verify token expiration
3. Validate request headers
4. Check rate limit status
5. Review backend error codes 