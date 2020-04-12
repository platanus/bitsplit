<template>
  <div>
    <p>Route: {{ routeName }}</p>

    <router-link :to="signInRoute">sign in</router-link>
    <router-link :to="signUpRoute">sign up</router-link>
    <router-link :to="homeRoute">Home</router-link>
  </div>
</template>

<script>
import { mapState, mapGetters } from 'vuex'
export default {
  name: 'Landing',
  data() {
    return {
      routeName: 'Landing',
      signInRoute: 'sign-in',
      signUpRoute: 'sign-up',
      homeRoute: 'home'
    }
  }
}
</script>

<style lang="scss"></style>