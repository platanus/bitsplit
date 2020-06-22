<template>
  <header class="flex items- justify-around px-8 py-1 bg-secondary">
    <template v-if="signedIn">
      <button
        type="button"
        class="block text-gray-500 hover:text-white focus:text-white focus:outline-none"
      >
        <router-link class="flex" :to="homeRoute">
          <img
            :src="bitsplitLogo"
            class="py-2 px-2 w-4/6 bg-gray-400 rounded"
          />
        </router-link>
      </button>
      <button
        type="button"
        class="block text-gray-500 hover:text-white focus:text-white focus:outline-none"
      >
        <router-link class="flex" :to="payRoute">
          <i class="material-icons text-center mr-2">payments</i>
          Pagar
        </router-link>
      </button>
      <button
        v-if="splitwiseSignedIn"
        type="button"
        class="block text-gray-500 hover:text-white focus:text-white focus:outline-none"
      >
        <router-link class="flex" :to="splitwiseRoute">
          <i class="material-icons text-center mr-2">people</i>
          Splitwise
        </router-link>
      </button>
      <button
        v-else
        type="button"
        class="block text-gray-500 hover:text-white focus:text-white focus:outline-none"
      >
        <button class="flex" @click="openSplitwiseUrl()">
          <i class="material-icons text-center mr-2">people</i>
          Splitwise
        </button>
      </button>
      <NavBarNotifications class="flex" />
      <button
        type="button"
        class="block text-gray-500 hover:text-white focus:text-white focus:outline-none"
      >
        <router-link class="flex" :to="profileRoute">
          <i class="material-icons text-center mr-2">account_circle</i>
          Mi perfil
        </router-link>
      </button>
      <button
        type="button"
        class="block mr-8 text-gray-500 hover:text-white focus:text-white focus:outline-none"
      >
        <button class="flex" @click="signOut()">
          <i class="material-icons text-center mr-2">exit_to_app</i>
          Cerrar Sesión
        </button>
      </button>
    </template>
    <template v-else>
      <button
        type="button"
        class="block text-gray-500 py-2 hover:text-white focus:text-white focus:outline-none"
      >
        <router-link :to="signInRoute">
          Iniciar sesión
        </router-link>
      </button>
      <button
        type="button"
        class="block text-gray-500 py-2 hover:text-white focus:text-white focus:outline-none"
      >
        <router-link :to="signUpRoute">
          Registrarse
        </router-link>
      </button>
    </template>
  </header>
</template>

<script>
import { mapGetters, mapActions, mapState } from 'vuex';
import NavBarNotifications from '../components/NavBarNotifications';

import logo from '../assets/bitsplit-logo.svg';

export default {
  name: 'NavBar',
  data() {
    return {
      signInRoute: '/sign-in',
      signUpRoute: '/sign-up',
      homeRoute: '/home',
      budaRoute: '/buda',
      landingRoute: '/',
      payRoute: '/payment',
      splitwiseRoute: '/splitwise',
      profileRoute: '/profile/', // No borrar el ultimo '/',
      bitsplitLogo: logo,
    };
  },
  components: {
    NavBarNotifications,
  },
  methods: {
    ...mapActions('user', ['signOut', 'getSplitwiseUrl']),
    ...mapActions('notification', ['bindNotifications', 'unbindNotifications']),
    openSplitwiseUrl() {
      this.getSplitwiseUrl()
        .then(res => {
          window.open(res.authorize_url);
          this.$router.push('/home');
        })
        .catch(err => {
          console.error(err);
        });
    },
  },
  computed: {
    ...mapState('user', ['currentUser', 'signOutLoading']),
    ...mapGetters('user', ['signedIn', 'budaSignedIn', 'splitwiseSignedIn']),
  },
  created() {
    if (this.signedIn) {
      this.bindNotifications();
    } else {
      this.unbindNotifications();

      if (!(this.$router.history.current.path === '/splitwise-connection')) {
        this.$router.push('/');
      }
    }
  },
  watch: {
    signedIn(isSignedIn) {
      // Cuando cambia el estado de signedIn
      if (isSignedIn) {
        this.$router.push('/home');
        this.bindNotifications();
      } else {
        this.$router.push('/');
        this.unbindNotifications();
      }
    },
  },
};
</script>
