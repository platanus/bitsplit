<template>
  <div class="w-full py-6">
    <div class="flex">
      <div class="w-1/2">
        <div class="relative mb-2">
          <div
            v-if="!budaSignedIn"
            class="w-12 h-12 mx-auto bg-white border-2 border-gray-200 rounded-full text-lg text-black flex justify-center"
          >
            <i class="material-icons self-center">account_balance_wallet</i>
          </div>
          <div
            v-else
            class="w-12 h-12 mx-auto bg-green-500 rounded-full text-lg text-white flex items-center justify-center"
          >
            <i class="material-icons self-center">account_balance_wallet</i>
          </div>
        </div>

        <div class="text-xs text-center md:text-base">
          Buda
        </div>
      </div>

      <div class="w-1/2">
        <div class="relative mb-2">
          <div
            class="absolute flex align-center items-center align-middle content-center"
            style="
              width: calc(100% - 3.5rem);
              top: 50%;
              transform: translate(-50%, -50%);
            "
          >
            <div
              class="w-full bg-gray-200 rounded items-center align-middle align-center flex-1"
            >
              <!-- Current progress bar -->
              <div
                v-if="currentStep === 'splitwise'"
                class="w-0 bg-green-400 py-1 rounded"
                style="width: 85%;"
              />
              <div
                v-else
                class="w-0 bg-gray-200 py-1 rounded"
                style="width: 85%;"
              />
            </div>
          </div>

          <div
            v-if="!splitwiseDone"
            class="w-12 h-12 mx-auto bg-white border-2 border-gray-200 rounded-full text-lg text-black flex items-center justify-center"
          >
            <i class="material-icons md-48 self-center">call_split</i>
          </div>
          <div
            v-else
            class="w-12 h-12 mx-auto bg-green-500 rounded-full text-lg text-white flex items-center justify-center"
          >
            <i class="material-icons md-48 self-center">call_split</i>
          </div>
        </div>

        <div class="text-xs text-center md:text-base">
          Splitwise
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import { mapState, mapGetters } from 'vuex';

export default {
  name: 'InputLabel',
  props: {
    fieldFor: String,
  },
  computed: {
    ...mapState('onBoarding', ['splitwiseDone', 'currentStep']),
    ...mapGetters('user', ['budaSignedIn']),
  },
};
</script>
