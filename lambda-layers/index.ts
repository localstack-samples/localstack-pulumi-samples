// Copyright 2016-2017, Pulumi Corporation.  All rights reserved.

import * as pulumi from "@pulumi/pulumi";
import * as aws from "@pulumi/aws";
import { asset } from "@pulumi/pulumi";

const config = new pulumi.Config("aws");

let layer = new aws.lambda.LayerVersion("my-layer-version", {
    code: new asset.AssetArchive({
        "index.js": new asset.StringAsset(
            "exports.handler = (e, c, cb) => cb(null, {statusCode: 200, body: 'Hello, world!'});",
        ),
    }),
    compatibleRuntimes: [
        aws.lambda.Runtime.NodeJS12dX,
        aws.lambda.Runtime.NodeJS14dX,
    ],
    layerName: "lambda_layer_name",
});

export let layerSize = layer.sourceCodeSize;
export let layerArn = layer.arn;
