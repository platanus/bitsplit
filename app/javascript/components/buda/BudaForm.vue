<template>
  <div>
    <form @submit.prevent="handleSubmit()">
      <div>
        <textField>
          Ingresa el API_KEY y API_SECRET de tu cuenta Buda. Puedes acceder a
          ellos en tu perfil de
          <a href="https://www.buda.com">www.buda.com</a>
        </textField>
      </div>
      <div>
        <inputLabel field-name="API_KEY">
          key
        </inputLabel>
        <passwordInput field-id="apiKey" field-name="apiKey" v-model="apiKey" />
      </div>
      <div>
        <inputLabel field-name="API_SECRET">
          apiSecret
        </inputLabel>
        <passwordInput
          field-id="apiSecret"
          field-name="apiSecret"
          v-model="apiSecret"
        />
      </div>
      <div>
        <inputLabel field-for="password">
          Confirma tu contraseña Bitsplit
        </inputLabel>
        <passwordInput
          field-id="password"
          field-name="password"
          v-model="password"
        />
      </div>
      <div>
        <submitButton :loading="budaSignInLoading" width="full">
          Sincronizar Buda
        </submitButton>
      </div>
    </form>
  </div>
</template>

<script>
import { mapActions, mapState } from 'vuex';
import passwordInput from '../PasswordInput';
import submitButton from '../SubmitButton';
import inputLabel from '../InputLabel';
import textField from '../TextField';

export default {
  name: 'BudaForm',
  data() {
    return {
      routeName: 'BudaForm',
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
    ...mapState('user', ['currentUser', 'budaSignInLoading']),
  },
  methods: {
    ...mapActions('user', ['budaSignIn']),
    ...mapActions('onBoarding', ['currentStepOk']),
    handleSubmit() {
      const { apiKey, apiSecret, password } = this;
      if (apiKey && apiSecret && password) {
        this.budaSignIn({
          api_key: apiKey,
          api_secret: apiSecret,
          password,
        })
          .then(() => {
            if (this.onBoardingScreen) {
              this.currentStepOk();
            } else {
              this.$router.go();
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
