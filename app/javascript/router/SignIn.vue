<template>
  <div>
    <p>Route: {{ routeName }}</p>
    <form @submit.prevent="handleSubmit">
      <div>
        <label for="email">email</label>
        <input type="text" v-model="email" name="email" />
      </div>
      <div>
        <label htmlFor="password">Password</label>
        <input type="password" v-model="password" name="password" />
      </div>
      <div>
        <button :disabled="loading">
          Login
        </button>
      </div>
    </form>
  </div>
</template>

<script>
import { mapActions, mapState } from 'vuex'

export default {
  name: 'SignIn',
  data() {
    return {
      routeName: 'Sign In',
      email: '',
      password: '',
      loading: false
    }
  },
  computed: {
    ...mapState('user', ['currentUser'])
  },
  methods: {
    ...mapActions('user', ['signIn']),
    handleSubmit(e) {
      const { email, password } = this
      if (email && password) {
        this.signIn({ email, password })
          .then(() => {
            console.log('success')
            this.$router.push('/home')
          })
          .catch(() => {
            console.log('error')
          })
      }
    }
  }
}
</script>

<style lang="scss"></style>
