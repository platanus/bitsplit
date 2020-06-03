<template>
  <div>
    <h1>Base del perfil de usuario</h1>
    <!-- Quizas los botones ponerlos en un menu lateral si se ve bien (algo asi https://tailwindcomponents.com/component/app-sidebar)-->
    <div class="bg-white">
      <nav class="flex flex-col sm:flex-row">
        <button :class="getTabClass('/')">
          <router-link to="/profile/">
            Home
          </router-link>
        </button>
        <button :class="getTabClass('/buda')">
          <router-link to="/profile/buda">
            Buda
          </router-link>
        </button>
        <button :class="getTabClass('/splitwise')">
          <router-link to="/profile/splitwise">
            Splitwise
          </router-link>
        </button>
        <button :class="getTabClass('/wallet')">
          <router-link to="/profile/wallet">
            Wallet
          </router-link>
        </button>
        <button :class="getTabClass('/settings')">
          <router-link to="/profile/settings">
            settings
          </router-link>
        </button>
      </nav>
    </div>
    <!-- en router-view, se muestra el componente segun la ruta en /profile/:name => app/js/router/index.js -->
    <router-view />
  </div>
</template>

<script>
export default {
  name: 'Profile',
  methods: {
    getTabClass(tab) {
      // Dado el current url, retorna la clase correspondiente
      const url = this.$router.history.current.path;
      const activeTab = url.replace('/profile', '');

      if (tab !== activeTab) {
        return 'text-gray-600 py-4 px-6 block hover:text-blue-500 focus:outline-none';
      }

      return 'text-gray-600 py-4 px-6 block hover:text-blue-500 focus:outline-none text-blue-500 border-b-2 font-medium border-blue-500';
    },
  },
};
</script>

<style lang="scss"></style>
