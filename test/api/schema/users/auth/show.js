exports.response = {
  type: "object",
  required: ["role_code"],
  properties: {
    role_code: {
      type: "string"
    },
    fcm_topic_name: {
      type: "string"
    }
  }
};
