<template>
  <div class="lg:flex">
    <div class="flex items-center">
      <div class="flex-column ml-4">
        <div v-if="currentUser.picture_url">
          <img
            :src="currentUser.picture_url.large"
            class="rounded-full border-solid border-white border-2 mt-3 w-24 ml-6 mr-6 mb-3"
          />
        </div>
        <div v-else>
          <img
            src="https://t4.ftcdn.net/jpg/00/64/67/63/240_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg"
            class="rounded-full border-solid border-white border-2 mt-3 w-24 ml-6 mr-6 mb-3"
          />
        </div>
        <router-link
          class="btn-secondary ext-black font-bold p-1 ml-2 mt-4 rounded focus:outline-none"
          to="/profile/settings"
        >
          Cerrar sesión
        </router-link>
      </div>
      <div class="w-1/5 txt-card text-sm mb-4 mt-4 ml-4">
        <p class="text-black leading-none mb-4 mt-4 font-bold">
          Nombre Usuario
        </p>
        <p class="text-grey-dark mb-4 mt-4">
          {{ currentUser.email }}
        </p>
        <p class="text-grey-dark mb-4 mt-4">
          <span class="font-bold"> Wallet Actual:</span>
          {{ currentUser.wallet }}
        </p>
        <submitButton>
          <router-link to="/profile/settings">
            Editar
          </router-link>
        </submitButton>
      </div>
      <div class="w-2/3 text-center flex bg-white mr-4 my-4 rounded-md">
        <div class="w-1/3 bg-indigo-200 rounded-md p-2 mb-4 mr-2">
          <img :src="bitsplitLogo" class="p-5 mt-10" />
          <p class="txt-card font-light my-4">
            ¡Abona o retira dinero desde tu cuenta de Bitsplit!
          </p>
          <submitButton>
            <router-link class="px-6" to="/profile/Wallet">
              Ir
            </router-link>
          </submitButton>
        </div>
        <div class="w-1/3 bg-green-200 rounded-md p-2 mb-4 mr-2">
          <p class="flex mt-4 mb-4">
            <img :src="splitwiseLogo" />
            <span class="text-xl mt-6 ml-2">Splitwise</span>
          </p>
          <div v-if="splitwiseSignedIn" class="mt-6 txt-card">
            <h2>¡Ya estás conectado a Splitwise!</h2>
          </div>
          <div v-else class="mb-6">
            <h2 class="font-bold text-red-600 p-2 txt-card">
              ¡No tienes tu cuenta de Splitwise sincronizada!
            </h2>
            <p class="font-light p-2 mb-2 txt-card">
              Sincroniza con Splitwise y paga tus cuentas de forma fácil y
              rápida
            </p>
            <submitButton>
              <router-link class="px-6" to="/profile/splitwise">
                Sincronizar
              </router-link>
            </submitButton>
          </div>
        </div>
        <div class="w-1/3 bg-blue-200 rounded-md p-6 mb-4">
          <p class="text-5xl flex font-bold">
            <img :src="budaLogo" class="w-20 h-20 flex-shrink-0" />
            <span class="font-bold text-xl ml-4 mt-6">Buda</span>
          </p>
          <div v-if="budaSignedIn" class="mt-6 txt-card">
            <h2>¡Ya estás conectado a Buda!</h2>
          </div>
          <div v-else>
            <h2 class="font-bold text-red-600 mt-4 py-2 txt-card">
              ¡No tienes tu cuenta de Buda sincronizada!
            </h2>
            <p class="font-light p-2 mb-2 txt-card">
              Sincroniza con Buda para poder enviar y recibir dinero en tu
              cuenta.
            </p>
            <submitButton>
              <router-link class="px-6" to="/profile/buda">
                Sincronizar
              </router-link>
            </submitButton>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import { mapState, mapGetters } from 'vuex';
import submitButton from '../components/SubmitButton';
import buda from '../assets/buda-icon.png';
import splitwise from '../assets/splitwise-logo.svg';
import bitsplit from '../assets/bitsplit-logo.svg';

export default {
  name: 'ProfileCard',
  data() {
    return {
      budaLogo: buda,
      splitwiseLogo: splitwise,
      bitsplitLogo: bitsplit,
    };
  },
  props: {
    classmod: {
      type: String,
      default: '',
    },
  },
  components: {
    submitButton,
  },
  computed: {
    ...mapState('user', ['currentUser', 'userBalanceCLP', 'userBalanceBTC']),
    ...mapGetters('user', ['budaSignedIn', 'splitwiseSignedIn']),
  },
};
</script>
