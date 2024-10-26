import {KeyManagementServiceClient} from '@google-cloud/kms';
import {credentialConfig} from './credential-config.js';

import crc32c from 'fast-crc32c';

const projectId = process.env.MPC_PROJECT_ID;
const locationId = 'global';
const keyRingId = 'mpc-keys';
const keyId = 'mpc-key';

// Instantiates a client
const client = new KeyManagementServiceClient({
  credentials: credentialConfig,
});

// Build the key name
const keyName = client.cryptoKeyPath(projectId, locationId, keyRingId, keyId);

export const decryptSymmetric = async (ciphertext) => {
  const ciphertextCrc32c = crc32c.calculate(ciphertext);
  const [decryptResponse] = await client.decrypt({
    name: keyName,
    ciphertext,
    ciphertextCrc32c: {
      value: ciphertextCrc32c,
    },
  });

  // Optional, but recommended: perform integrity verification on decryptResponse.
  // For more details on ensuring E2E in-transit integrity to and from Cloud KMS visit:
  // https://cloud.google.com/kms/docs/data-integrity-guidelines
  if (
    crc32c.calculate(decryptResponse.plaintext) !==
    Number(decryptResponse.plaintextCrc32c.value)
  ) {
    throw new Error('Decrypt: response corrupted in-transit');
  }

  const plaintext = decryptResponse.plaintext.toString();

  return plaintext;
};
