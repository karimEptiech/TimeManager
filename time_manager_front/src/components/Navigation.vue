<template>
  <nav class="navbar navbar-expand-lg navbar-light bg-light">
    <div class="container-fluid">
      <a class="navbar-brand" href="#"><img src="/logotech.png" alt="Logo" /></a>
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent"
        aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarSupportedContent">
        <ul class="navbar-nav me-auto mb-2 mb-lg-0">
          <li class="nav-item">
            <router-link style="text-decoration: none;"  to="/WorkingTime/0"><a class="nav-link">Working Time</a>
            </router-link>
          </li>
          <li class="nav-item">
            <router-link style="text-decoration: none;" to="/users"><a class="nav-link">Users</a>
            </router-link>
          </li>
          <li class="nav-item">
            <router-link style="text-decoration: none;" to="/Clock/1"><a class="nav-link">Clock in/out</a>
            </router-link>
          </li>
          <li class="nav-item">
            <router-link style="text-decoration: none;" to="/WorkingTimeCreate"><a class="nav-link">Create WK-Time</a>
            </router-link>
          </li>

        </ul>
        <ul>
          <li class="nav-item" v-if="connect" @click="disconnect">Logout</li>
        </ul>

        <!--
          <form class="d-flex">
            <User />
          </form>
        -->
      </div>
    </div>
  </nav>
</template>

<script>
// import User from './User.vue'
import User from './User.vue';
export default {
  name: "Navigation",
  data() {
    return {
      connect: false
    }
  },
  methods: {
    isconnected() {
      this.connect = (window.localStorage.getItem('roleID') != null)
    },
    disconnect(){
      window.localStorage.clear();
    }
  },
  components: {
    User
  },
  mounted() {
    setInterval(() => {
      this.isconnected();
    }, 1000);
    this.isconnected()
    console.log(this.connect)
  }
};
</script>

<style scoped>
#formLogin {
  padding: 15px;
  min-width: 300px;
}

.navbar-brand img {
  width: 75px;
}

ul {
  font-weight: bold;
}
</style>