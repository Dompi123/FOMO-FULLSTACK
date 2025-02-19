const fs = require('fs');
const https = require('https');

class SecureHandler {
  constructor() {
    // Load API keys from environment
    this.geminiKey = process.env.GEMINI_API_KEY;
    this.perplexityKey = process.env.PERPLEXITY_API_KEY;
    
    if (!this.geminiKey || !this.perplexityKey) {
      throw new Error('API keys not found in environment');
    }
    
    this.credits = { gemini: 50, perplexity: 10 };
    this.usedCredits = { gemini: 0, perplexity: 0 };
  }

  async analyzeSwiftFiles(files) {
    if (this.usedCredits.gemini >= this.credits.gemini) {
      throw new Error('Gemini API credit limit reached');
    }

    const content = files.join('\n\n');
    
    return new Promise((resolve, reject) => {
      const req = https.request({
        hostname: 'generativelanguage.googleapis.com',
        path: '/v1beta/models/gemini-pro:generateContent',
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${this.geminiKey}`
        }
      }, (res) => {
        let data = '';
        res.on('data', chunk => data += chunk);
        res.on('end', () => {
          this.usedCredits.gemini++;
          try {
            const response = JSON.parse(data);
            resolve(response);
          } catch (error) {
            reject(error);
          }
        });
      });

      req.on('error', reject);
      
      req.write(JSON.stringify({
        contents: [{
          parts: [{
            text: `Analyze the following Swift code for type safety issues and iOS 14+ navigation compatibility:\n\n${content}`
          }]
        }]
      }));
      
      req.end();
    });
  }

  async generateNavigationFallbacks(navigationCode) {
    if (this.usedCredits.perplexity >= this.credits.perplexity) {
      throw new Error('Perplexity API credit limit reached');
    }

    return new Promise((resolve, reject) => {
      const req = https.request({
        hostname: 'api.perplexity.ai',
        path: '/chat/completions',
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${this.perplexityKey}`
        }
      }, (res) => {
        let data = '';
        res.on('data', chunk => data += chunk);
        res.on('end', () => {
          this.usedCredits.perplexity++;
          try {
            const response = JSON.parse(data);
            resolve(response);
          } catch (error) {
            reject(error);
          }
        });
      });

      req.on('error', reject);
      
      req.write(JSON.stringify({
        model: 'sonar-pro',
        messages: [{
          role: 'user',
          content: `Generate iOS 14 compatible navigation fallback code for:\n\n${navigationCode}`
        }]
      }));
      
      req.end();
    });
  }

  getUsageReport() {
    return {
      gemini: {
        used: this.usedCredits.gemini,
        remaining: this.credits.gemini - this.usedCredits.gemini
      },
      perplexity: {
        used: this.usedCredits.perplexity,
        remaining: this.credits.perplexity - this.usedCredits.perplexity
      }
    };
  }
}

module.exports = SecureHandler; 