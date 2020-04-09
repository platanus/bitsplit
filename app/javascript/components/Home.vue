<template>
  <div>
    <h1>Route: {{ routeName }}</h1>
    <p>Current user: {{ currentUser }}</p>
    <button @click="signOut">Log Out</button>
  </div>
</template>

<script>
import { mapState, mapGetters, mapActions } from 'vuex'

export default {
  name: 'Home',
  data() {
    return {
      routeName: 'Home',
      signInRoute: 'sign-in',
      signUpRoute: 'sign-up'
    }
  },

  computed: {
    ...mapState('user', ['currentUser'])
  },
  methods: {
    ...mapActions('user', ['signOut']),
    handleLogOut() {
      this.logOut().then(() => {
        this.$router.push('/')
      })
    }
  }
}
</script>

<style lang="scss"></style>
