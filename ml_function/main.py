import requests
import os
import numerapi
import polars as pl
import functions_framework


DISCORD_WEBHOOK_URL = os.environ["DISCORD_WEBHOOK_URL"]
NUMERAI_PUBLIC_ID = os.environ["NUMERAI_PUBLIC_ID"]
NUMERAI_SECRET_KEY = os.environ["NUMERAI_SECRET_KEY"]
NUMERAI_MODEL_ID = os.environ["NUMERAI_MODEL_ID"]


def post_discord(message):
    requests.post(os.environ.get("DISCORD_WEBHOOK_URL"), {"content": message})


@functions_framework.http
def numerai_submit(request):
    try:
        public_id = NUMERAI_PUBLIC_ID
        secret_key = NUMERAI_SECRET_KEY
        model_name = NUMERAI_MODEL_ID
        napi = numerapi.NumerAPI(public_id, secret_key)
        napi.download_dataset(
            "v4.1/live_example_preds.parquet", "live_example_preds.parquet"
        )

        pl.read_parquet("./live_example_preds.parquet").select(
            ["id", "prediction"]
        ).write_csv(f"tournament_predictions_{model_name}.csv")

        # Numerai Training and Submit code
        model_id = napi.get_models()[model_name]
        napi.upload_predictions(
            f"tournament_predictions_{model_name}.csv", model_id=model_id
        )
        post_discord(f"Submit Success")

    except Exception as e:
        post_discord(f"Numerai Submit Failure. Error: {str(e)}")
