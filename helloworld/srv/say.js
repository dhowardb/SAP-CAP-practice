// module.exports = (say) => {
//   say.on("hello", (req) => `Hello ${req.data.to}!`);
// };

module.exports = class say {
  hello(req) {
    return `Hello ${req.data.to}!`;
  }
};
