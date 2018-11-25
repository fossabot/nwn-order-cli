package ordercli

import (
	"fmt"
	"strings"

	"github.com/spf13/cobra"
)

func packModule(p string) {
	fmt.Println("Starting to pack module")
	fmt.Println(p)
}

func unpackModule(f string) {
	fmt.Println("Starting to unpack module")
	fmt.Println(f)
}

func compileNSS(p string) {
	fmt.Println("Starting to compile nss")
	fmt.Println(p)
}

func main() {
	var cmdUnpack = &cobra.Command{
		Use:   "unpack [module to unpack]",
		Short: "Unpack .mod file",
		Long:  `Unpack .mod file`,
		Run: func(cmd *cobra.Command, args []string) {
			var packPath = strings.Join(args, " ")
			if packPath == "" {
				fmt.Println("Filepath required to unpack module file")
				return
			} else {
				packModule(packPath)
			}
		},
	}

	var cmdPack = &cobra.Command{
		Use:   "pack [module to unpack]",
		Short: "Pack src folder to .mod file",
		Long:  `Pack src folder to .mod file`,
		Run: func(cmd *cobra.Command, args []string) {
			var packPath = strings.Join(args, " ")
			if packPath == "" {
				fmt.Println("Path required to pack module file")
				return
			} else {
				packModule(packPath)
			}
		},
	}

	var cmdCompileNSS = &cobra.Command{
		Use:   "compile [folder to compile]",
		Short: "Compile NSS.",
		Long:  `Compile NSS.`,
		Run: func(cmd *cobra.Command, args []string) {
			var compilePath = strings.Join(args, " ")
			if compilePath == "" {
				fmt.Println("Path required to compile nss")
				return
			} else {
				compileNSS(compilePath)
			}
		},
	}

	var Source string
	cmdCompileNSS.Flags().StringVarP(&Source, "source", "s", "", "Source directory to read from")

	var rootCmd = &cobra.Command{Use: "order-cli"}

	rootCmd.AddCommand(cmdUnpack, cmdPack, cmdCompileNSS)
	rootCmd.Execute()
}
