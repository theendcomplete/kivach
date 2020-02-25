const Api = require("../config/api")();

module.exports = {
  admin: {
    login: "userlogin",
    email: "user@email.com",
    password: "xxxxxxxxx"
  },
  authorize: function(role, done) {
    Api.post("/users/auth")
      .send({
        login: this[role].login,
        password: this[role].password
      })
      .expect("Content-type", /json/)
      .expect(200)
      .end((err, res) => {
        if (err) {
          done();
          return;
        }
        this[role].token = res.body.token;
        done();
      });
  }
};
