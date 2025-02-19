const fs = require('fs');
const path = require('path');
const SecureHandler = require('./secure_api.js');

async function findSwiftFiles(dir) {
  const files = [];
  const items = fs.readdirSync(dir, { withFileTypes: true });
  
  for (const item of items) {
    const fullPath = path.join(dir, item.name);
    if (item.isDirectory()) {
      files.push(...await findSwiftFiles(fullPath));
    } else if (item.name.endsWith('.swift')) {
      files.push(fullPath);
    }
  }
  
  return files;
}

async function main() {
  try {
    // Find all Swift files in Features directory
    const featuresPath = path.join('FOMO_FINAL', 'FOMO_FINAL', 'Features');
    const swiftFiles = await findSwiftFiles(featuresPath);
    
    // Read file contents
    const fileContents = swiftFiles.map(file => ({
      path: file,
      content: fs.readFileSync(file, 'utf8')
    }));
    
    // Initialize handler
    const handler = new SecureHandler();
    
    // Run analysis
    console.log('Analyzing Swift files...');
    const analysis = await handler.analyzeSwiftFiles(fileContents.map(f => f.content));
    
    // Generate report
    const report = [
      '# Type Safety Audit Report\n',
      '## Files Analyzed\n',
      ...fileContents.map(f => `- ${f.path}`),
      '\n## Analysis Results\n',
      analysis.candidates?.[0]?.content?.parts?.[0]?.text || 'No analysis results available.',
      '\n## API Usage\n',
      JSON.stringify(handler.getUsageReport(), null, 2)
    ].join('\n');
    
    // Save report
    fs.writeFileSync(
      path.join('.cursor', 'reports', 'type_audit_direct.md'),
      report
    );
    
    console.log('Analysis complete. Report saved to .cursor/reports/type_audit_direct.md');
    
  } catch (error) {
    console.error('Error:', error.message);
    process.exit(1);
  }
}

main(); 