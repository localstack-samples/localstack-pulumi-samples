import * as pulumi from "@pulumi/pulumi";
import * as aws from "@pulumi/aws";

const config = new pulumi.Config("aws");

const bucket = new aws.s3.Bucket("testbucket", {
    serverSideEncryptionConfiguration: {
        rule: {
            applyServerSideEncryptionByDefault: {
                sseAlgorithm: "AES256",
            },
        },
    },
    forceDestroy: true,
});

const queue = new aws.sqs.Queue("queue", {
    visibilityTimeoutSeconds: 300,
});

queue.onEvent("subscription", async (event) => {
    console.log("Received: " + JSON.stringify(event, null, 2));
    // Node.js 18 and later Lambda runtimes ship the AWS SDK v3, not v2
    const { S3Client, PutObjectCommand } = await import("@aws-sdk/client-s3");
    const s3 = new S3Client({});

    const recordFile = "lastEvent.json";

    console.log("Storing sqs message to S3.");
    await s3.send(new PutObjectCommand({
        Bucket: bucket.id.get(),
        Key: recordFile,
        Body: JSON.stringify(event),
    }));
    console.log("Stored sqs message to S3.");
}, { batchSize: 1 });

export const queueUrl = queue.id;
export const bucketUrl = pulumi.interpolate `s3://${bucket.id}`;
