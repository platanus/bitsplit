<template>
  <header class="flex items- justify-around px-4 py-3 bg-gray-900">
    <template v-if="signedIn">
      <button type="button" class="block text-gray-500 hover:text-white focus:text-white focus:outline-none">
        <router-link :to="homeRoute">Home</router-link>
      </button>
      <button type="button" class="block text-gray-500 hover:text-white focus:text-white focus:outline-none">
        <router-link :to="budaRoute">Buda</router-link>
      </button>
      <button type="button" class="block text-gray-500 hover:text-white focus:text-white focus:outline-none">
        <button @click="handleLogOut">Log Out</button>
      </button>
    </template>
    <template v-else>
      <button type="button" class="block text-gray-500 hover:text-white focus:text-white focus:outline-none">
        <router-link :to="landingRoute">Landing</router-link>
      </button>
      <button type="button" class="block text-gray-500 hover:text-white focus:text-white focus:outline-none">
        <router-link :to="signInRoute">Iniciar sesión</router-link>
      </button>
      <button type="button" class="block text-gray-500 hover:text-white focus:text-white focus:outline-none">
        <router-link :to="signUpRoute">Registrarse</router-link>
      </button>
    </template>
  </header>
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
      budaRoute: 'buda',
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
          console.error(err)
        })
    }
  },
  computed: {
    ...mapState('user', ['currentUser']),
    ...mapGetters('user', ['signedIn'])
  }
}
</script>