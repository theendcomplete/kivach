exports.response = {
  type: "object",
  required: ["rows", "total_count"],
  properties: {
    rows: {
      type: "array",
      items: require("./_user").user
    },
    total_count: {
      type: "integer"
    }
  }
};
