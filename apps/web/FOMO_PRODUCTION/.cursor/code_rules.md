# FOMO Code Review Rules

## General Guidelines
- Follow Swift style guide
- Use SwiftUI best practices
- Maintain MVVM architecture
- Include unit tests for new features
- Document public APIs

## Security Requirements
- No hardcoded credentials
- Use Keychain for sensitive data
- Validate all user input
- Implement proper error handling
- Follow PCI compliance guidelines

## Performance Guidelines
- Optimize network calls
- Use async/await for concurrency
- Minimize main thread work
- Cache appropriately
- Follow memory management best practices

## UI/UX Requirements
- Support Dark Mode
- Follow iOS HIG
- Implement proper error states
- Add loading indicators
- Support accessibility

## Testing Requirements
- Unit test coverage > 80%
- UI test critical paths
- Mock network responses
- Test error scenarios
- Include performance tests

## Documentation
- Use proper XML documentation
- Document complex algorithms
- Include usage examples
- Document dependencies
- Keep README up to date

## Collaboration Rules
- Review PRs within 24 hours
- Address all comments
- No force pushes to main
- Keep PRs focused
- Use conventional commits

## AI Review Focus
- Security vulnerabilities
- Performance issues
- Code style consistency
- Potential bugs
- Architecture patterns
- Test coverage
- Documentation completeness

## Automated Checks
```json
{
    "critical": [
        "security_scan",
        "unit_tests",
        "lint_check"
    ],
    "required": [
        "type_check",
        "build_verify",
        "dependency_audit"
    ],
    "recommended": [
        "performance_check",
        "memory_leak_scan",
        "complexity_analysis"
    ]
}
``` 