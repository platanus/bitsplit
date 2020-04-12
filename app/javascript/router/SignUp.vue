<template id="full">
  <div id="SignUpForm">
    <center>
      <div class="w-full max-w-xs">
        <form
          @submit.prevent="handleSubmit"
          class="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4"
        >
          <div class="mb-4">
            <label
              class="block text-gray-700 text-sm font-bold mb-2"
              for="email"
            >
              Email
            </label>
            <input
              class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
              id="email"
              type="text"
              placeholder="Email"
              v-model="email"
              name="email"
            />
          </div>
          <div class="mb-4">
            <label
              class="block text-gray-700 text-sm font-bold mb-2"
              for="password"
            >
              Password
            </label>
            <input
              class="shadow appearance-none border border-red-500 rounded w-full py-2 px-3 text-gray-700 mb-3 leading-tight focus:outline-none focus:shadow-outline"
              id="confirm_password"
              type="password"
              v-model="confirm_password"
              name="confirm_password"
              placeholder="******************"
            />

            <label
              class="block text-gray-700 text-sm font-bold mb-2"
              for="password"
            >
              Repeat your password
            </label>
            <input
              class="shadow appearance-none border border-red-500 rounded w-full py-2 px-3 text-gray-700 mb-3 leading-tight focus:outline-none focus:shadow-outline"
              id="password"
              type="password"
              v-model="password"
              name="password"
              placeholder="******************"
            />
          </div>
          <div class="mb-6">
          <label
              class="block text-gray-700 text-sm font-bold mb-2"
              for="buda_user"
            >
              Buda User
            </label>
            <input
              class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
              id="buda_user"
              type="text"
              placeholder="Buda User"
              v-model="buda_user"
              name="buda_user"
            />
          </div>
            <button
              class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
              :disabled="loading"
            >
              Sign Up
            </button>
        </form>
      </div>
    </center>
  </div>
</template>
<script>
import { mapActions, mapState } from 'vuex'

export default {
  name: 'SignUp',
  data() {
    return {
      routeName: 'SignUp',
      email: '',
      password: '',
      confirm_password: '',
      buda_user: '',
      loading: false
    }
  },
  computed: {
    ...mapState('user', ['currentUser'])
  },
  methods: {
    ...mapActions('user', ['signUp']),
    handleSubmit(e) {
      const { email, password , confirm_password} = this
      console.log(e)
      if (email && password && (password === confirm_password)) {
        console.log('Correct confirmation')
        this.signUp({ email, password, buda_user })
          .then(() => {
            // TODO logger  
            console.log('success')
          })
<<<<<<< HEAD
          .catch(err => {
=======
          .catch((err) => {
>>>>>>> [web] update: signup
            console.log(err)
          })
      }
    }
  }
}
</script>

<style scoped>
#SignUpForm {
  margin-top: 60px;
  margin-bottom: 60px;
}
</style>
