// Example with express-rate-limit
   const rateLimit = require('express-rate-limit');
   
   const authLimiter = rateLimit({
       windowMs: 15 * 60 * 1000, // 15 minutes
       max: 5, // Maximum 5 requests
       message: 'Too many login attempts, please try again later'
   });
   
   app.post('/api/v1/auth', authLimiter, (req, res) => {
       // Authentication logic
   });
