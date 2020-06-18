<template>
  <div>
    <div class="txt-card h-auto px-48">
      <div class="flex md:flex-row-reverse flex-wrap">
        <div class="w-full md:w-3/4 p-4 text-center">
          <div class="text-left pl-4 pt-8 mb-8">
            <span class="text-base text-xl mr-2">{{ currentUser.email }}</span>
          </div>
          <form @submit.prevent="handleSubmit()">
            <div>
              <inputLabel field-name="wallet">
                Nueva wallet
              </inputLabel>
              <select-input
                field-name="newWallet"
                field-id="newWallet"
                v-model="newWallet"
                :options="walletOptions"
                :name-mappings="walletNameMappings"
              />
            </div>
            <div>
              <inputLabel field-name="password">
                Contraseña actual
              </inputLabel>
              <passwordInput
                field-id="password"
                field-name="password"
                v-model="password"
              />
            </div>
            <submitButton :loading="loading" class="">
              <p>Cambiar Wallet</p>
            </submitButton>
          </form>
        </div>
        <div class="w-full md:w-1/4 p-4 text-center">
          <div class="w-full relative md:w-3/4 text-center mt-8">
            <button class="flex">
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
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import { mapState, mapGetters, mapActions } from 'vuex';
import SelectInput from '../Select';
import InputLabel from '../InputLabel';
import passwordInput from '../PasswordInput';
import SubmitButton from '../SubmitButton';

export default {
  name: 'ProfileSettings',
  data() {
    return {
      password: '',
      newWallet: '',
      walletOptions: ['buda', 'bitsplit'],
      walletNameMappings: { buda: 'Buda', bitsplit: 'Bitsplit' },
      loading: false,
    };
  },
  components: {
    SelectInput,
    InputLabel,
    passwordInput,
    SubmitButton,
  },
  mounted() {
    this.newWallet = this.currentUser.wallet;
    if (!this.budaSignedIn) {
      this.walletOptions = ['bitsplit'];
    }
  },
  methods: {
    ...mapActions('user', ['updateCurrentUser']),
    handleSubmit() {
      const { password, newWallet } = this;
      if (newWallet === this.currentUser.wallet || !password) return;

      this.loading = true;

      this.updateCurrentUser({ password, wallet: newWallet })
        .then(() => {
          this.loading = false;
          this.$router.go();
        })
        .catch(() => {
          this.loading = false;
        });
    },
  },
  computed: {
    ...mapState('user', ['currentUser', 'userBalanceCLP', 'userBalanceBTC']),
    ...mapState('user', ['currentUser']),
    ...mapGetters('user', ['budaSignedIn', 'splitwiseSignedIn']),
  },
};
</script>
