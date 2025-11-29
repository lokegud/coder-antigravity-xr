# Contributing to Antigravity XR Coder Template

Thanks for your interest in improving this template! Here's how you can help.

## Ways to Contribute

- **Bug Reports**: Found an issue? Open an issue with details
- **Feature Requests**: Have ideas? Let us know what would be useful
- **Documentation**: Help improve clarity and add examples
- **Code**: Submit PRs for improvements

## Quick Contribution Guide

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-improvement`
3. Make your changes
4. Test the template builds successfully
5. Commit with clear messages: `git commit -m "Add: description of change"`
6. Push to your fork: `git push origin feature/your-improvement`
7. Open a Pull Request

## Testing Changes

Before submitting a PR, verify:

```bash
# Test Docker build
cd coder-templates/antigravity-xr
docker build -t test-antigravity -f build/Dockerfile .

# Verify Terraform syntax (if you have terraform installed)
terraform fmt -check
terraform validate

# Test on actual Coder instance if possible
coder templates push antigravity-xr-test
```

## Areas Needing Help

- GPU passthrough configuration examples
- Alternative base images (Alpine, Debian, etc.)
- ARM64 support
- CI/CD integration examples
- Physical device connection guides
- Performance optimizations

## Code of Conduct

- Be respectful and constructive
- Focus on improving the template for everyone
- Help others learn and grow

## Questions?

Open an issue or discussion - we're happy to help!
