# FOMO Collaboration Security Rules

## Authentication Requirements
- GitHub 2FA mandatory
- Device authorization required
- Session token expiration: 24h
- Auto-revoke on security violations

## Access Controls
```json
{
    "permissions": {
        "view": ["*.swift", "*.md", "*.json"],
        "comment": ["*.swift", "*.md"],
        "edit": []
    },
    "restrictions": {
        "blocked_files": ["**/secrets.json", "**/Credentials.swift"],
        "sensitive_patterns": ["API_KEY", "SECRET_", "PASSWORD"]
    }
}
```

## Security Requirements
- Minimum Cursor version: 2.4.0
- Encrypted session channels
- Audit logging enabled
- Network validation required
- PCI compliance checks active

## Session Configuration
```json
{
    "session": {
        "max_duration": "24h",
        "idle_timeout": "30m",
        "max_participants": 5,
        "require_approval": true
    },
    "monitoring": {
        "log_access": true,
        "track_changes": true,
        "alert_on_violation": true
    }
}
```

## Device Requirements
- Secure enclave available
- Latest OS version
- Firewall enabled
- No jailbreak/root

## Network Security
- TLS 1.3 required
- Certificate pinning enabled
- Proxy detection
- VPN validation

## Compliance
- PCI DSS requirements
- GDPR compliance
- SOC2 controls
- Data residency rules

## Audit Requirements
- Session activity logging
- Access attempt tracking
- Security event monitoring
- Compliance reporting 