import claude_vision
print("✅ UI validated" if claude_vision.match_baseline("./FOMO-FULLSTACK/Screenshots") else "❌ UI drift")
