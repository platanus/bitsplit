<template>
  <header class="flex items- justify-around px-4 py-3 bg-gray-900">
    <template v-if="signedIn">
      <button
        type="button"
        class="block text-gray-500 hover:text-white focus:text-white focus:outline-none"
      >
        <router-link :to="homeRoute">Inicio</router-link>
      </button>
      <button
        type="button"
        class="block text-gray-500 hover:text-white focus:text-white focus:outline-none"
      >
        <router-link :to="budaRoute">Buda</router-link>
      </button>
      <button
        v-if="budaSignedIn"
        type="button"
        class="block text-gray-500 hover:text-white focus:text-white focus:outline-none"
      >
        <router-link :to="payRoute">Pagar</router-link>
      </button>
      <NavBarNotifications />

      <button
        type="button"
        class="block text-gray-500 hover:text-white focus:text-white focus:outline-none"
      >
        <button @click="signOut()">Cerrar Sesión</button>
      </button>
    </template>
    <template v-else>
      <button
        type="button"
        class="block text-gray-500 hover:text-white focus:text-white focus:outline-none"
      >
        <router-link :to="landingRoute">Bienvenido!</router-link>
      </button>
      <button
        type="button"
        class="block text-gray-500 hover:text-white focus:text-white focus:outline-none"
      >
        <router-link :to="signInRoute">Iniciar sesión</router-link>
      </button>
      <button
        type="button"
        class="block text-gray-500 hover:text-white focus:text-white focus:outline-none"
      >
        <router-link :to="signUpRoute">Registrarse</router-link>
      </button>
    </template>
  </header>
</template>

<script>
import { mapGetters, mapActions, mapState } from 'vuex'
import NavBarNotifications from '../components/NavBarNotifications'

export default {
  name: 'navBar',
  data() {
    return {
      signInRoute: 'sign-in',
      signUpRoute: 'sign-up',
      homeRoute: 'home',
      budaRoute: 'buda',
      landingRoute: '/',
      payRoute: 'payment',
      documents: []
    }
  },
  components: {
    NavBarNotifications
  },
  methods: {
    ...mapActions('user', ['signOut']),
    ...mapActions('notification', ['bindNotifications', 'unbindNotifications'])
  },
  computed: {
    ...mapState('user', ['currentUser']),
    ...mapGetters('user', ['signedIn', 'budaSignedIn'])
  },
  created() {
    if (!this.signedIn) {
      this.unbindNotifications()
      this.$router.push('/')
    } else {
      this.bindNotifications()
    }
  },
  watch: {
    signedIn(isSignedIn) {
      // Cuando cambia el estado de signedIn
      if (!isSignedIn) {
        this.$router.push('/')
        this.unbindNotifications()
      } else {
        this.$router.push('/home')
        this.bindNotifications()
      }
    }
  }
}
</script>
