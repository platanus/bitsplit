<template>
  <div>
    <div class="txt-card h-auto px-20">
      <div class="flex px-40 md:flex-row-reverse flex-wrap">
        <div class="w-full p-4 text-center">
          <form
            class="bg-gray-100 p-4 rounded shadow-lg"
            @submit.prevent="handleUpdate()"
          >
            <label
              class="txt-field text-left block uppercase tracking-wide text-black text-xs font-bold mb-2"
              for="grid-last-name"
            >
              Ingresa tu nombre
            </label>
            <textInput
              field-id="userName"
              field-type="text"
              field-name="userName"
              :value="userName"
              v-model="userName"
            />
            <label
              class="txt-field text-left block uppercase tracking-wide text-black text-xs font-bold my-2"
              for="grid-last-name"
            >
              Ingresa tu Apellido
            </label>
            <textInput
              field-id="userLastName"
              field-type="text"
              field-name="userLastName"
              :value="userLastName"
              v-model="userLastName"
            /><label
              class="txt-field text-left block uppercase tracking-wide text-black text-xs font-bold mt-4"
              for="grid-last-name"
            >
              Agrega tu foto de perfil
            </label>
            <textInput
              field-id="userPhoto"
              field-type="text"
              field-name="userPhoto"
              :value="userPhoto"
              v-model="userPhoto"
            /><label
              class="txt-field text-center block uppercase tracking-wide text-black text-xs font-bold mt-4"
              for="grid-last-name"
            >
              Selecciona tu fecha de nacimiento
            </label>
            <DatePicker
              class="mb-6 mt-2"
              min="1930"
              max="2021"
              :default="selectedDate"
              v-model="selectedDate"
            />
            <submitButton :loading="loading" class="">
              <p>Actualizar</p>
            </submitButton>
          </form>
          <form
            class="bg-gray-100 p-4 rounded shadow-lg mt-6"
            @submit.prevent="handleSubmit()"
          >
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
import DatePicker from '../DatePicker';
import textInput from '../Input';

export default {
  name: 'ProfileSettings',
  data() {
    return {
      password: '',
      newWallet: '',
      walletOptions: ['buda', 'bitsplit'],
      walletNameMappings: { buda: 'Buda', bitsplit: 'Bitsplit' },
      loading: false,
      selectedDate: '',
      userName: '',
      userLastName: '',
      userPhoto: '',
    };
  },
  components: {
    SelectInput,
    InputLabel,
    passwordInput,
    SubmitButton,
    DatePicker,
    textInput,
  },
  mounted() {
    this.newWallet = this.currentUser.wallet;
    if (!this.budaSignedIn) {
      this.walletOptions = ['bitsplit'];
    }
  },
  created() {
    this.selectedDate = this.currentUser.birth_date;
    this.userName = this.currentUser.name;
    this.userLastName = this.currentUser.last_name;
    this.userPhoto = this.currentUser.picture;
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
    handleUpdate() {
      const { userName, userLastName, userPhoto, selectedDate } = this;

      this.loading = true;

      this.updateCurrentUser({
        name: userName,
        last_name: userLastName,
        picture: userPhoto,
        birth_date: selectedDate,
      })
        .then(() => {
          this.loading = false;

          this.getCurrentUser();
        })
        .catch(() => {
          this.loading = false;
        });
    },
  },
  computed: {
    ...mapState('user', [
      'currentUser',
      'userBalanceCLP',
      'userBalanceBTC',
      'getCurrentUser',
    ]),
    ...mapState('user', ['currentUser']),
    ...mapGetters('user', ['budaSignedIn', 'splitwiseSignedIn']),
  },
};
</script>
