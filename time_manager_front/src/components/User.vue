<template>
  <div class="d-flex flex-column center">
    <div class="p-2">
      <input v-if="!status" v-model="email" class="form-control me-2" type="search" placeholder="email"
        aria-label="Search" />

      <input v-if="status && !isModify" v-model="email" class="form-control me-2" readonly type="search"
        placeholder="{{email}}" aria-label="Search" />

      <input v-if="status && isModify" v-model="email" class="form-control me-2" type="search" placeholder="email"
        aria-label="Search" />
    </div>
    <div class="p-2">
      <input v-if="!status" v-model="username" class="form-control me-2" type="search" placeholder="username"
        aria-label="Search" />
      <input v-if="status && !isModify" v-model="username" class="form-control me-2" readonly type="search"
        placeholder="{{username}}" aria-label="Search" />
      <input v-if="status && isModify" v-model="username" class="form-control me-2" type="search"
        placeholder="{{username}}" aria-label="Search" />
    </div>
  </div>
  <div class="d-flex flex-column center crudCol">
    <div class="p-2" v-if="!status">
      <button @click="getUser" class="btn btn-outline-success" type="submit">
        Sign in
      </button>
    </div>
    <div class="p-2" v-if="!status">
      <button @click="createUser" class="btn btn-outline-success" type="submit">
        Sign up
      </button>
    </div>
    <div class="p-2" v-if="status & !isModify">
      <button @click="isModify = !isModify" class="btn btn-outline-info modify" type="submit">
        modify
      </button>
    </div>
    <div class="p-2" v-if="isModify">
      <button @click="updateUser" class="btn btn-outline-success modify" type="submit">
        Validate modify
      </button>
    </div>
    <div class="" v-if="status">
      <button @click="deleteUser" class="btn btn-outline-danger btn1 " type="submit">
        delete
      </button>
      <button @click="disconnectedUser" class="btn btn-outline-warning btn2" type="submit">Disconnect</button>
    </div>
  </div>
</template>
<script>
import axios from "axios";
export default {
  name: "Home",
  data() {
    return {
      id: 0,
      email: "",
      username: "",
      status: false,
      isModify: false,
    };
  },
  methods: {
    get_email() {
      return this.email;
    },
    getUser() {
      axios
        .get(
          `http://localhost:4000/api/users?email=${this.email}&username=${this.username}`
        )
        .then((response) => {
          this.id = response.data.id;
          this.status = true;
          alert('Hello ' + this.data.usernames)
        })
        .catch((error) => {
          console.log(error.response.status);
        });
    },
    deleteUser() {
      axios
        .delete(`http://localhost:4000/api/users/${this.id}`)
        .then((response) => {
          this.status = false;
          console.log(response);
        })
        .catch((error) => {
          console.log(error.response.status);
        });
    },
    createUser() {
      console.log(this.email, this.username);
      axios
        .post(`http://localhost:4000/api/users`, {
          email: this.email,
          username: this.username,
        })
        .then((response) => {
          alert('account created succesfuly')
          console.log(response);
        })
        .catch((error) => {
          alert('something went wrong')
          console.log(error.response.status);
        });
    },
    updateUser() {
      axios
        .put(`http://localhost:4000/api/users/${this.id}`, {
          email: this.email,
          username: this.username,
        })
        .then((response) => {
          this.isModify = false;
          console.log(response);
        })
        .catch((error) => {
          console.log(error.response.status);
        });
    },
    disconnectedUser() {
      this.$data.id = 0;
      this.$data.email = '';
      this.$data.username = '';
      this.$data.isModify = false;
      this.$data.status = false;
      alert('disconnected successfuly')
    }
  },
};
</script>

<style scoped>
.modify {
  position: relative;
  left: 35px;
}

.btn1 {
  width: 40%;
  margin-right: 5px;
}

.btn2 {
  padding-left: 10px;
}

.shrink {
  display: block;
  position: relative;
  right: 50px;
}

.crudCol {
  position: relative;
  left: -75px
}

.red {
  width: 50%;
  margin-right: 0px;
  font-size: 10px;
  position: relative;
  left: 10px
}

.myrow {
  position: relative;
  left: 80px;
}

input {
  max-width: 60%;
}

button {
  font-size: small;
  margin-bottom: 10px;
  width: 80px;
}
</style>