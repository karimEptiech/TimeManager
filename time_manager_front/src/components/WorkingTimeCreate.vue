<template>
    <div class=" container workingTime mt-5">
      <h2 class="p-5 pb-0">WorkingTime</h2>
      <div class="row  m-5 d-flex justify-content-center">
        <div class="col-sm ">
          <label>Start Date</label>
          <input type="datetime-local" class="datePicker" v-model="startDate"/>
        </div>
        <div class="col-sm">
          <label>End Date</label>
          <input type="datetime-local" class="datePicker" v-model="endDate"/>
        </div>
        <div class="col-sm userID">
          <label>User ID</label>
          <input class="userIDInput" placeholder="ID User" v-model="userID" />
        </div>
        <div class="col-12 mt-3">
          <button @click="createWorkingTime" class="btn btnValidation" type="submit">Submit form</button>
        </div>
      </div>
    </div>
   </template> 

<script>
import { ref, onMounted } from 'vue';
import axios from "axios";
export default {

  name: "workingtimecreate",
  data() {
    return {
      startDate: new Date().toISOString().substr(0, 10),
      endDate: new Date().toISOString().substr(0, 10),
      userID: "123",
      activeUserID: window.localStorage.getItem("userID")
    }
  },

  methods: {
    createWorkingTime() {
      console.log(this.startDate)
      let data = {
        start: this.startDate + ':00Z',
        end: this.endDate+ ':00Z'
      }
      axios
        .post(`http://localhost:4000/admin/workingtimes/${this.userID}`, data,
        {
          headers: {
            Authorization: `Bearer ${window.localStorage.getItem('jwt')}`,
            "x-csrf-token": `${window.localStorage.getItem('csrf')}`
          }
        })
        .then((response) => {
          alert('workingtime created succesfuly')
          console.log(response);
        }).catch((error) => {
          console.log('something went wrong' + error)
        })
    }
},
}

</script>


<style scoped>
.datePicker {
  width: 300px;
}

.btnValidation {
  background-color: #AAAEB7;
  box-shadow: 1px 1px #e6e4e4;
}

.btnValidation:hover {
  background-color: #8f939c;
}

.workingTime {
  border: #AAAEB7 2px solid;
  border-radius: 4px;
}

.userID {
  display: grid;

}

.userIDInput {
  border: 1px solid #AAAEB7;
  width: 100px;
  border-radius: 4px;

}

.input-group-append {
  cursor: pointer;
}
</style>
