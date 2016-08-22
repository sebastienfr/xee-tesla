package main

import (
	"encoding/base64"
	"fmt"
	"os"
	"time"

	"github.com/urfave/cli"

	"strconv"

	"github.com/jsgoecke/tesla"
)

var (
	// splash
	header, _ = base64.StdEncoding.DecodeString("")

	// Version is the version of the software
	Version string
	// BuildStmp is the build date
	BuildStmp string
	// GitHash is the git build hash
	GitHash string

	// command line parameters
	port      = 8020
	confFile  = "config.json"
	logLevel  = "warning"
	logFormat = "text_color"
)

func main() {

	// print header
	fmt.Println(string(header))

	// setup time ref to UTC
	time.Local = time.UTC

	// create cli app
	cliApp := cli.NewApp()
	cliApp.EnableBashCompletion = true
	cliApp.Usage = "xee-tesla bridge service"
	timeStmp, err := strconv.Atoi(BuildStmp)
	if err != nil {
		timeStmp = 0
	}
	cliApp.Version = Version + ", build on " + time.Unix(int64(timeStmp), 0).String() + ", git hash " + GitHash
	cliApp.Name = "delta"
	cliApp.Authors = []cli.Author{cli.Author{Name: "sfr"}}
	cliApp.Copyright = "sebastienfr " + strconv.Itoa(time.Now().Year())

	// define flags
	cliApp.Flags = []cli.Flag{
		cli.IntFlag{
			Value: port,
			Name:  "port",
			Usage: "Set the listening port of the webserver",
		},
		cli.StringFlag{
			Value: confFile,
			Name:  "conf",
			Usage: "Set the path of the main configuration file",
		},
		cli.StringFlag{
			Value: logLevel,
			Name:  "logl",
			Usage: "Set the output log level (debug, info, warning, error)",
		},
		cli.StringFlag{
			Value: logFormat,
			Name:  "logf",
			Usage: "Set the log formatter (logstash or text)",
		},
	}

	// define main loop
	cliApp.Action = func(c *cli.Context) error {
		// parse parameters
		port = c.Int("port")
		confFile = c.String("conf")
		logLevel = c.String("logl")
		logFormat = c.String("logf")

		fmt.Print("* --------------------------------------------------- *\n")
		fmt.Printf("|   port                    : %d\n", port)
		fmt.Printf("|   configuration file      : %s\n", confFile)
		fmt.Printf("|   logger level            : %s\n", logLevel)
		fmt.Printf("|   logger format           : %s\n", logFormat)
		fmt.Print("* --------------------------------------------------- *\n")

		// TODO
		// use tesla go API to retrieve tesla data
		// 1st step log them into a file
		// 2nd step send them to xee, but need to create car, etc to have it working

		// TODO remove test purpose
		client, err := tesla.NewClient(
			&tesla.Auth{
				ClientID:     os.Getenv("TESLA_CLIENT_ID"),
				ClientSecret: os.Getenv("TESLA_CLIENT_SECRET"),
				Email:        os.Getenv("TESLA_USERNAME"),
				Password:     os.Getenv("TESLA_PASSWORD"),
			})
		if err != nil {
			panic(err)
		}

		vehicles, err := client.Vehicles()
		if err != nil {
			panic(err)
		}

		vehicle := vehicles[0]
		status, err := vehicle.MobileEnabled()
		if err != nil {
			panic(err)
		}

		fmt.Println(status)

		return nil
	}

	// start the cliApp
	cliApp.Run(os.Args)

}
