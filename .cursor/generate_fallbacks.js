const fs = require('fs');
const path = require('path');
const SecureHandler = require('./secure_api.js');

async function main() {
  try {
    // Read existing navigation code
    const navigationPath = path.join('FOMO_FINAL', 'FOMO_FINAL', 'Core', 'Navigation');
    const navigationFiles = fs.readdirSync(navigationPath)
      .filter(f => f.endsWith('.swift'))
      .map(f => ({
        path: path.join(navigationPath, f),
        content: fs.readFileSync(path.join(navigationPath, f), 'utf8')
      }));
    
    // Initialize handler
    const handler = new SecureHandler();
    
    // Generate fallbacks
    console.log('Generating navigation fallbacks...');
    const result = await handler.generateNavigationFallbacks(
      navigationFiles.map(f => f.content).join('\n\n')
    );
    
    // Extract Swift code from response
    const fallbackCode = result.choices?.[0]?.message?.content || '';
    
    // Save fallback code
    const outputPath = path.join('FOMO_FINAL', 'FOMO_FINAL', 'Core', 'Navigation', 'FallbackHandlers.swift');
    fs.writeFileSync(outputPath, fallbackCode);
    
    console.log('Generated fallback handlers saved to:', outputPath);
    console.log('\nAPI Usage:', JSON.stringify(handler.getUsageReport(), null, 2));
    
  } catch (error) {
    console.error('Error:', error.message);
    process.exit(1);
  }
}

main(); 