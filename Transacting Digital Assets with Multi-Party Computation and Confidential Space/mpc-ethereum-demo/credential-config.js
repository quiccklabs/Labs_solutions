export const credentialConfig = {
  type: 'external_account',
  audience: `//iam.googleapis.com/projects/${process.env.MPC_PROJECT_NUMBER}/locations/global/workloadIdentityPools/trusted-workload-pool/providers/attestation-verifier`,
  subject_token_type: 'urn:ietf:params:oauth:token-type:jwt',
  token_url: 'https://sts.googleapis.com/v1/token',
  credential_source: {
    file: '/run/container_launcher/attestation_verifier_claims_token',
  },
  service_account_impersonation_url: `https://iamcredentials.googleapis.com/v1/projects/-/serviceAccounts/trusted-mpc-account@${process.env.MPC_PROJECT_ID}.iam.gserviceaccount.com:generateAccessToken`,
};
