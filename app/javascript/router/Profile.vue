<template>
  <div>
    <div class="flex-grow container mx-auto sm:px-4 pt-6 pb-8">
      <div
        class="bg-white border-t border-b sm:border-l sm:border-r sm:rounded shadow mb-6"
      >
        <div class="lg:flex">
          <ProfileCard classmod="self-center" />
        </div>
      </div>
      <div class="flex flex-wrap -mx-4">
        <div class="w-full px-4">
          <div class="bg-white border-t border-b sm:rounded sm:border shadow">
            <div class="border-b">
              <div class="flex justify-between px-6 -mb-px">
                <div class="bg-blue-dark md:block md:bg-white md:border-b">
                  <div class="container mx-auto px-4">
                    <div class="md:flex">
                      <div class="flex -mb-px mr-8">
                        <button :class="getTabClass('/')">
                          <router-link class="flex" to="/profile/">
                            <i class="material-icons text-center mr-2">home</i>
                            Balances
                          </router-link>
                        </button>
                      </div>
                      <div class="flex -mb-px mr-8">
                        <button :class="getTabClass('/buda')">
                          <router-link class="flex" to="/profile/buda">
                            <i class="material-icons text-center mr-2"
                              >attach_money</i
                            >
                            Buda
                          </router-link>
                        </button>
                      </div>
                      <div class="flex -mb-px mr-8">
                        <button :class="getTabClass('/splitwise')">
                          <router-link class="flex" to="/profile/splitwise">
                            <i class="material-icons text-center mr-2">group</i>
                            Splitwise
                          </router-link>
                        </button>
                      </div>
                      <div class="flex -mb-px mr-8">
                        <button :class="getTabClass('/wallet')">
                          <router-link class="flex" to="/profile/wallet">
                            <i class="material-icons text-center mr-2"
                              >account_balance_wallet</i
                            >
                            Wallet
                          </router-link>
                        </button>
                      </div>
                      <div class="flex -mb-px">
                        <button :class="getTabClass('/settings')">
                          <router-link class="flex" to="/profile/settings">
                            <i class="material-icons text-center mr-2"
                              >settings</i
                            >
                            Configuración
                          </router-link>
                        </button>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div>
              <div class="text-center py-4">
                <!-- en router-view, se muestra el componente segun la ruta en /profile/:name => app/js/router/index.js -->
                <router-view />
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState, mapGetters } from 'vuex';
import ProfileCard from '../components/ProfileCard';

export default {
  name: 'Profile',
  data() {
    return {
      routeName: 'profile',
    };
  },
  components: {
    ProfileCard,
  },
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
  computed: {
    ...mapState('user', ['currentUser', 'userBalanceCLP', 'userBalanceBTC']),
    ...mapGetters('user', ['budaSignedIn']),
  },
};
</script>

<style lang="scss"></style>
