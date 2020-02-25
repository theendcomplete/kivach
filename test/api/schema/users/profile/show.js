exports.response = {
  type: "object",
  required: [
    "login",
    "email",
    "role_code",
    "status_code",
    "first_name",
    "last_name",
    "demo_id",
    "districts",
    "agencies"
  ],
  properties: require("../_user").user.properties
};
