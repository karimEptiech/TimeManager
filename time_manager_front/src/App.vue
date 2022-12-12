<template>
  <header>
    <Navigation />
  </header>

  <main>
    <router-view></router-view>
  </main>
</template>

<script>
import Navigation from "./components/Navigation.vue";
import "bootstrap/dist/css/bootstrap.css";
import "bootstrap/dist/js/bootstrap.js";
export default {
  components: {
    Navigation,
  },
  connexionStatus: {
    status: false,
    username: "",
    email: "",
  },
};
</script>

<style scoped></style>
