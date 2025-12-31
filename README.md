# AWS S3 hosting + Cloudfront
![AWS S3 hosting + Cloudfront architecture][arch-image]

## Cloudfront alternative domains
To allow alternative domains to be served in cloudfront, the domain will need to be added to `Alternate domain names` for the cloudfront distribution.

Before that, the alternative domains will need to be secured using a certificate.

### Creating a Certificate in AWS ACM
> **NOTE:** The certificate is required to be located in **us-east-1** region to work with Cloudfront distribution.

1. Open AWS Certificate manager in the AWS console.
{ADD IMAGE}
2. Click on `Request` button in the top right
3. Select `Request a public certificate`, then next
4. Input the required domains for the certificate
```
<domain>
<*.domain>
```
5. Select `DNS validation`
6. Request

### Validating the certificate using DNS
After creating the certificate, AWS will generate CNAME records that will be used to validate ownership of the domain

To validate, perform the following:
1. Open the certificate in AWs Certificate manager.
2. Note the CNAME name and CNAME value
3. Open Cloudflare DNS page.
4. Add a new Record
  1. Select CNAME type
  2. Paste the CNAME name from aws into the name field
  3. Paste the CNAME value from aws into the value field
  4. Add comment
  5. Save
5. Wait couple of minutes, AWS status will update to verified on certificate page in AWS console.

### Associate the domain and certificate with Cloudfront distribution
In terraform, fetch the certificate ARN from aws using the domain in the certificate:
```terraform
# Load the domain certificates from ACM
data "aws_acm_certificate" "domain-cert" {
  region = "us-east-1"
  domain = var.domain
}
```

Add the domain name and certificate to cloudfront distribution
```terraform
resource "aws_cloudfront_distribution" "s3-website-distribution" {
  ...

  # example: [ "static-web.example.com" ]
  aliases = [ "${var.app_name}.${var.domain}" ]

  viewer_certificate {
    acm_certificate_arn = data.aws_acm_certificate.domain-cert.arn
    ssl_support_method = "sni-only"
  }

  ...
}
```

## Setting up Cloudflare subdomain DNS to point to cloudfront
After deploying cloudfront distribution, note the `Distribution domain name` for the disrtribution.

Add the following CNAME record in cloudflare DNS
```
CNAME RECORD
  NAME: <sub-domain>
  value: <AWS Distribution domain name>
```


# React + TypeScript + Vite

This template provides a minimal setup to get React working in Vite with HMR and some ESLint rules.

Currently, two official plugins are available:

- [@vitejs/plugin-react](https://github.com/vitejs/vite-plugin-react/blob/main/packages/plugin-react) uses [Babel](https://babeljs.io/) (or [oxc](https://oxc.rs) when used in [rolldown-vite](https://vite.dev/guide/rolldown)) for Fast Refresh
- [@vitejs/plugin-react-swc](https://github.com/vitejs/vite-plugin-react/blob/main/packages/plugin-react-swc) uses [SWC](https://swc.rs/) for Fast Refresh

## React Compiler

The React Compiler is not enabled on this template because of its impact on dev & build performances. To add it, see [this documentation](https://react.dev/learn/react-compiler/installation).

## Expanding the ESLint configuration

If you are developing a production application, we recommend updating the configuration to enable type-aware lint rules:

```js
export default defineConfig([
  globalIgnores(['dist']),
  {
    files: ['**/*.{ts,tsx}'],
    extends: [
      // Other configs...

      // Remove tseslint.configs.recommended and replace with this
      tseslint.configs.recommendedTypeChecked,
      // Alternatively, use this for stricter rules
      tseslint.configs.strictTypeChecked,
      // Optionally, add this for stylistic rules
      tseslint.configs.stylisticTypeChecked,

      // Other configs...
    ],
    languageOptions: {
      parserOptions: {
        project: ['./tsconfig.node.json', './tsconfig.app.json'],
        tsconfigRootDir: import.meta.dirname,
      },
      // other options...
    },
  },
])
```

You can also install [eslint-plugin-react-x](https://github.com/Rel1cx/eslint-react/tree/main/packages/plugins/eslint-plugin-react-x) and [eslint-plugin-react-dom](https://github.com/Rel1cx/eslint-react/tree/main/packages/plugins/eslint-plugin-react-dom) for React-specific lint rules:

```js
// eslint.config.js
import reactX from 'eslint-plugin-react-x'
import reactDom from 'eslint-plugin-react-dom'

export default defineConfig([
  globalIgnores(['dist']),
  {
    files: ['**/*.{ts,tsx}'],
    extends: [
      // Other configs...
      // Enable lint rules for React
      reactX.configs['recommended-typescript'],
      // Enable lint rules for React DOM
      reactDom.configs.recommended,
    ],
    languageOptions: {
      parserOptions: {
        project: ['./tsconfig.node.json', './tsconfig.app.json'],
        tsconfigRootDir: import.meta.dirname,
      },
      // other options...
    },
  },
])
```


## Setting up Custom domain in cloudflare

[arch-image]: ./docs//architecture.png