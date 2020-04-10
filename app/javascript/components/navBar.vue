<template>
  <div>
    <template v-if="signedIn">
      <router-link :to="homeRoute">Home</router-link>
      <button @click="handleLogOut">Log Out</button>
    </template>
    <template v-else>
      <router-link :to="landingRoute">landing</router-link>
      <router-link :to="signInRoute">sign in</router-link>
      <router-link :to="signUpRoute">sign up</router-link>
    </template>
  </div>
</template>

<script>
import { mapGetters, mapActions, mapState } from 'vuex'
export default {
  name: 'navBar',
  data() {
    return {
      signInRoute: 'sign-in',
      signUpRoute: 'sign-up',
      homeRoute: 'home',
      landingRoute: '/'
    }
  },
  methods: {
    ...mapActions('user', ['signOut']),
    handleLogOut() {
      this.signOut()
        .then(() => {
          this.$router.push('/')
        })
        .catch(err => {
          // Aviso de que hubo un error se muestra globalmente
          console.log(err)
        })
    }
  },
  computed: {
    ...mapState('user', ['currentUser']),
    ...mapGetters('user', ['signedIn'])
  }
}
</script>

