<template>
  <div class="users">
    <div class="container mt-3">
      <div class="row flex-lg-nowrap">
        <div class="col">
          <div class="row flex-lg-nowrap">
            <div class="col mb-3">
              <div class="e-panel card">
                <div class="card-body">
                  <div class="card-title">
                    <h6 class="mr-2">
                      <span>Users</span><small class="px-1">DashBoard</small>
                    </h6>
                  </div>
                  <div class="e-table">
                    <div class="table-responsive table-lg mt-3">
                      <table class="table table-bordered">
                        <thead>
                          <tr>
                            <th class="align-top">
                              <div
                                class="custom-control custom-control-inline custom-checkbox custom-control-nameless m-0">
                                <input type="checkbox" v-model="initialBox" true-value="yes" false-value="no"
                                  class="custom-control-input " id="all-items">
                              </div>
                            </th>
                            <th class="max-width">Name</th>
                            <th class="sortable">Email</th>
                            <th class="id">ID</th>
                            <th>Actions</th>
                          </tr>
                        </thead>
                        <tbody>
                          <tr v-for="user in users" :key="user.id">
                            <td class="align-middle">
                              <div
                                class="custom-control custom-control-inline custom-checkbox custom-control-nameless m-0 align-top">
                                <input @click="changeSelected($event)" type="checkbox"
                                  class="custom-control-input myCheckBoxs" id="item-2">
                                <label class="custom-control-label" for="item-2"></label>
                              </div>
                            </td>
                            <td class="text-nowrap align-middle">
                              {{ user.username }}
                            </td>
                            <td class="text-nowrap align-middle">
                              <span>{{ user.email }}</span>
                            </td>
                            <td class="text-nowrap align-middle">
                              <span>{{ user.id }}</span>
                            </td>
                            <td class="text-center align-middle">
                              <i class="fa fa-fw text-secondary cursor-pointer fa-toggle-on"></i>
                              <div class="btn-group align-top">
                                <button class="btn btn-sm btn-outline-secondary rounded-circle mr-1" type="button"
                                  data-bs-toggle="modal" v-bind:data-bs-target="'#exampleModal' + user.id">
                                  Edit
                                </button>
                                <button class="btn btn-sm btn-outline-secondary rounded-circle" type="button">
                                  <router-link style="text-decoration: none;" v-bind:to="'/WorkingTime/' + user.id">
                                    Show-WT</router-link>
                                  <i class="fa fa-trash"></i>
                                </button>
                              </div>
                              <div class="modal fade" v-bind:id="'exampleModal' + user.id" tabindex="-1"
                                aria-labelledby="exampleModalLabel" aria-hidden="true">
                                <div class="modal-dialog">
                                  <div class="modal-content">
                                    <div class="modal-header">
                                      <h5 class="modal-title" id="exampleModalLabel">Modifier {{ user.username }}</h5>
                                      <button type="button" class="btn-close" data-bs-dismiss="modal"
                                        aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                      <div class="input-group">
                                        <div class="input-group-prepend">
                                          <span class="input-group-text" v-bind:id="user.id">Email and Username</span>
                                        </div>
                                        <input type="text" v-model="dataUser.email_id[user.id]" class="form-control">
                                        <input type="text" v-model="dataUser.username_id[user.id]" class="form-control">
                                      </div>
                                    </div>
                                    <div class="modal-footer">
                                      <button type="button" class="btn btn-secondary"
                                        data-bs-dismiss="modal">Close</button>
                                      <button type="button" @click="updateUser(user.id)" class="btn btn-primary">Save
                                        changes</button>
                                    </div>
                                  </div>
                                </div>
                              </div>
                            </td>
                          </tr>
                        </tbody>
                      </table>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-12 col-lg-3 mb-3">
              <div class="card">
                <div class="card-body">
                  <div class="e-navlist e-navlist--active-bold">
                    <ul class="nav">
                      <li class="nav-item active"><a href="" class="nav-link"><span>All</span>&nbsp;<small>/&nbsp;
                            {{ this.usersNumber }}</small></a></li>
                      <li class="nav-item"><a href="#"
                          class="nav-link"><span>Active</span>&nbsp;<small>/&nbsp;16</small></a></li>
                      <li class="nav-item"><a href="" class="nav-link"><span>Selected</span>&nbsp;<small>/&nbsp;{{
                          this.selected
                      }}</small></a></li>
                    </ul>
                  </div>
                  <hr class="my-3" />
                  <div>
                    <div class="form-group">
                      <label>Date from - to:</label>
                      <div>
                        <input id="dates-range" class="form-control flatpickr-input" placeholder="01 Dec 17 - 27 Jan 18"
                          type="text" readonly="readonly" />
                      </div>
                    </div>
                    <div class="form-group">
                      <label>Search by Name:</label>
                      <div>
                        <input class="form-control w-100" type="text" placeholder="Name" value="" />
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- User Form Modal -->
          <div class="modal fade" role="dialog" tabindex="-1" id="user-form-modal">
            <div class="modal-dialog modal-lg" role="document">
              <div class="modal-content">
                <div class="modal-header">
                  <h5 class="modal-title">Create User</h5>
                  <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                  </button>
                </div>
                <div class="modal-body">
                  <div class="py-1">
                    <form class="form" novalidate="">
                      <div class="row">
                        <div class="col">
                          <div class="row">
                            <div class="col">
                              <div class="form-group">
                                <label>Full Name</label>
                                <input class="form-control" type="text" name="name" placeholder="John Smith"
                                  value="John Smith" />
                              </div>
                            </div>
                            <div class="col">
                              <div class="form-group">
                                <label>Username</label>
                                <input class="form-control" type="text" name="username" placeholder="johnny.s"
                                  value="johnny.s" />
                              </div>
                            </div>
                          </div>
                          <div class="row">
                            <div class="col">
                              <div class="form-group">
                                <label>Email</label>
                                <input class="form-control" type="text" placeholder="user@example.com" />
                              </div>
                            </div>
                          </div>
                          <div class="row">
                            <div class="col mb-3">
                              <div class="form-group">
                                <label>About</label>
                                <textarea class="form-control" rows="5" placeholder="My Bio"></textarea>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                      <div class="row">
                        <div class="col-12 col-sm-6 mb-3">
                          <div class="mb-2"><b>Change Password</b></div>
                          <div class="row">
                            <div class="col">
                              <div class="form-group">
                                <label>Current Password</label>
                                <input class="form-control" type="password" placeholder="••••••" />
                              </div>
                            </div>
                          </div>
                          <div class="row">
                            <div class="col">
                              <div class="form-group">
                                <label>New Password</label>
                                <input class="form-control" type="password" placeholder="••••••" />
                              </div>
                            </div>
                            <div class="col">
                              <div class="form-group">
                                <label>Confirm
                                  <span class="d-none d-xl-inline">Password</span></label>
                                <input class="form-control" type="password" placeholder="••••••" />
                              </div>
                            </div>
                          </div>
                        </div>
                        <div class="col-12 col-sm-5 offset-sm-1 mb-3">
                          <div class="mb-2"><b>Keeping in Touch</b></div>
                          <div class="row">
                            <div class="col">
                              <label>Email Notifications</label>
                              <div class="custom-controls-stacked px-2">
                                <div class="custom-control custom-checkbox">
                                  <input type="checkbox" class="custom-control-input" id="notifications-blog"
                                    checked="" />
                                  <label class="custom-control-label" for="notifications-blog">Blog posts</label>
                                </div>
                                <div class="custom-control custom-checkbox">
                                  <input type="checkbox" class="custom-control-input" id="notifications-news"
                                    checked="" />
                                  <label class="custom-control-label" for="notifications-news">Newsletter</label>
                                </div>
                                <div class="custom-control custom-checkbox">
                                  <input type="checkbox" class="custom-control-input" id="notifications-offers"
                                    checked="" />
                                  <label class="custom-control-label" for="notifications-offers">Personal Offers</label>
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                      <div class="row">
                        <div class="col d-flex justify-content-end">
                          <button class="btn btn-primary" type="submit">
                            Save Changes
                          </button>
                        </div>
                      </div>
                    </form>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div>
      <InteractivePieChart />
    </div>
  </div>

</template>

<script>
import InteractivePieChart from "./InteractivePieChart.vue"

import axios from 'axios'
export default {
  name: "Users",
  data() {
    return {
      users: null,
      initialBox: "no",
      selected: 0,
      usersNumber: 0,
      dataUser: {
        email_id: [],
        username_id: []
      },
    }
  }, methods: {

    changeSelected(event) {
      const val = event.target.checked

      if (val) {
        this.selected++
      } else {
        this.selected--
      }
      console.log(this.selected)
    },
    getAllUsers() {
      axios
        .get(
          `http://localhost:4000/admin/users/all`,{
                  headers: {
                    Authorization: `Bearer ${localStorage.getItem('jwt')}`,
                    "x-csrf-token": `${localStorage.getItem('csrf')}`
                  } 
            }
        )
        .then((response) => {
          response.data.forEach(e => {
            this.dataUser.email_id[e.id] = e.email
            this.dataUser.username_id[e.id] = e.username
          });
          this.users = response.data
        })
        .catch((error) => {
          console.log(error.response.status);
        });
    },
    updateUser(id) {
      axios
        .put('http://localhost:4000/api/users/' + id, {
          email: this.dataUser.email_id[id],
          username: this.dataUser.username_id[id],
          headers: {
            Authorization: `Bearer ${localStorage.getItem('jwt')}`,
            "x-csrf-token": `${localStorage.getItem('csrf')}`
          } 

        })
        .then((response) => {
          alert("sucess")
          this.users.forEach(user => {
            if (user.id == id) {
              user.email = this.dataUser.email_id[id]
              user.username = this.dataUser.username_id[id]
            }
          });
          console.log(response);
        })
        .catch((error) => {
          console.log('something went wrong')
          console.log(error.response.status);
        });
      return
    }
  },
  watch: {
    users: function (val) {
      this.usersNumber = this.users.length
    },
    initialBox: function (val) {
      var checksboxs = this.$el.querySelectorAll('.myCheckBoxs');
      checksboxs.forEach(e => {
        if (e.classList.contains('initialBox')) {
          if (e.checked == false) e.checked = true
          return
        }
        if ((e.checked == false)) {
          this.selected++
          e.checked = true
        } else {
          this.selected--
          e.checked = false
        }
      });
    }
  },
  components: {
    InteractivePieChart
  },
  mounted() {
    console.log('debut')
    this.getAllUsers();

  }
}

</script>

<style scoped>

</style>
