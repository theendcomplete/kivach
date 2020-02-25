exports.response = {
  type: "object",
  required: ["token"],
  properties: {
    token: {
      type: "string"
    },
    fcm_topic_name: {
      type: "string"
    }
  }
};
