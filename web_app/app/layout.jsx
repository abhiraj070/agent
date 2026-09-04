import "./globals.css";

export const metadata = {
  title: "Aaraam — Your personal assistant",
  description: "Say the chore once. Aaraam handles the calls and coordination.",
  icons: { icon: "/favicon.svg", shortcut: "/favicon.svg" },
};

export default function RootLayout({ children }) {
  return <html lang="en"><body>{children}</body></html>;
}
