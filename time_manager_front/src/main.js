import { createApp } from "vue";
import User from "./components/User.vue"
import App from "./App.vue";
import Home from "./components/Home.vue";
import WorkingTime from "./components/WorkingTime.vue"
import Clock from "./components/ClockManager.vue"
import WorkingTimeCreate from "./components/WorkingTimeCreate.vue"
import Datepicker from '@vuepic/vue-datepicker';
import Users from './components/Users.vue'
import '@vuepic/vue-datepicker/dist/main.css'
import { createWebHashHistory, createRouter } from "vue-router";
import 'bootstrap';

const routes = [
  {
    path: "/WorkingTime/:id(\\d+)",
    name: "workingTime",
    component: WorkingTime,
  },
  {
    path: "/",
    name: "Home",
    component: Home,
  },
  {
    path: "/Users",
    name: "Users",
    component: Users,
  },
  {
    path: "/Clock/:id(\\d+)",
    name: "Clock",
    component: Clock,
  },{
    path: "/WorkingTimeCreate",
    name: "workingTimecreate",
    component: WorkingTimeCreate,
  }
];

const router = createRouter({
  history: createWebHashHistory(),
  routes,
});

createApp(App).use(router).mount("#app");
