use actix_web::{App, HttpServer};
use clap::Parser;
use tracing::instrument;
use tracing_actix_web::TracingLogger;

use crate::cli::Args;
use actix_web::{get, HttpResponse, Responder};

mod cli {
    use clap::Parser;

    // TODO(name webserver here)
    /// Simple web server
    #[derive(Parser, Debug)]
    #[command(author, version, about, long_about = None)]
    pub struct Args {
        /// Address to serve health routes
        #[arg(long)]
        pub health_addr: String,
    }
}

#[get("/health")]
pub async fn health() -> impl Responder {
    HttpResponse::Ok()
}

#[instrument]
#[actix_web::main]
async fn main() -> anyhow::Result<()> {
    let args = Args::parse();

    Ok(
        HttpServer::new(|| App::new().wrap(TracingLogger::default()).service(health))
            .bind(args.health_addr)?
            .run()
            .await?,
    )
}
