<template>
  <form @submit.prevent="handleSubmit">
    <div>
      <textField>
        ¿Estás seguro de querer desconectar tu cuenta Buda? Por favor ingresa tu
        contraseña para confirmar
      </textField>
    </div>
    <div>
      <inputLabel field-for="password">
        Contraseña Bitsplit
      </inputLabel>
      <passwordInput
        field-id="password"
        field-name="password"
        v-model="password"
      />
    </div>
    <div>
      <submitButton>Confirmar</submitButton>
    </div>
  </form>
</template>

<script>
import { mapActions, mapState } from 'vuex';
import passwordInput from '../components/PasswordInput';
import submitButton from '../components/SubmitButton';
import inputLabel from '../components/InputLabel';
import textField from '../components/TextField';

export default {
  name: 'BudaLogoutForm',
  data() {
    return {
      routeName: 'BudaLogoutForm',
      apiKey: '',
      apiSecret: '',
      password: '',
    };
  },
  props: {
    onBoardingScreen: {
      type: Boolean,
      default: false,
    },
  },
  components: {
    passwordInput,
    submitButton,
    inputLabel,
    textField,
  },
  computed: {
    ...mapState('user', ['currentUser']),
  },
  methods: {
    ...mapActions('user', ['budaSignOut']),
    ...mapActions('component', ['changeBudaComp']),
    handleSubmit() {
      const { apiKey, apiSecret, password } = this;
      if (password) {
        this.budaSignOut({
          api_key: apiKey,
          api_secret: apiSecret,
          password,
        })
          .then(() => {
            if (this.onBoardingScreen) {
              this.changeBudaComp('BudaForm');
            } else {
              this.$router.push('/home');
            }
          })
          .catch(err => {
            console.error(err);
          });
      }
    },
  },
};
</script>
