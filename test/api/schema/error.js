exports.response = {
  type: "object",
  required: ["error_code", "error_text"],
  properties: {
    error_code: {
      type: "string"
    },
    error_text: {
      type: "string"
    }
  }
};
