"use client";

import { useEffect, useMemo, useRef, useState } from "react";

const activitySeed = [
  { time: "8:42 am", title: "Anil ji will meet you at Gate 2.", meta: "1 call · 38 sec" },
  { time: "Yesterday", title: "Coco’s walk is set for 6:30 pm.", meta: "1 call · 1 min" },
  { time: "Yesterday", title: "Dinner coordinated for 8 pm.", meta: "4 calls · 7 min" },
];

const paneerNodes = [
  { id: "amrita", person: "Amrita", action: "Check what’s at home", state: "Calling" },
  { id: "grocery", person: "Fresh Basket", action: "Order what’s missing", state: "Waiting" },
  { id: "bhim", person: "Bhim", action: "Cook paneer butter masala", state: "Waiting" },
  { id: "shanti", person: "Shanti", action: "Coordinate cleaning", state: "Waiting" },
];

const onboardingExamples = [
  { request: "Ask my driver to meet me at the gate in five minutes.", source: "Driver replied", result: "“I’ll be at Gate 2.”", initials: "DR" },
  { request: "Find out what time the househelp is coming today.", source: "Househelp replied", result: "“I’ll come around 6 pm.”", initials: "HH" },
  { request: "Coordinate dinner so everything is ready by eight.", source: "Dinner coordinated", result: "Groceries by 6:15. Dinner by 8.", initials: "✓" },
  { request: "Ask maintenance for an electrician on Sunday afternoon.", source: "Maintenance confirmed", result: "Electrician booked for Sunday, 3 pm.", initials: "MO" },
];

const personRoles = ["Driver", "Cook", "Nanny", "Househelp", "Dog walker", "Vendor", "Society office", "Other"];

function RolePicker({ autoFocus = false }) {
  return (
    <fieldset className="role-first">
      <legend><small>First, choose their role</small>Who are they to you?</legend>
      <div className="role-options">
        {personRoles.map((role, index) => (
          <label className="role-option" key={role}>
            <input type="radio" name="role" value={role} defaultChecked={index === 0} autoFocus={autoFocus && index === 0} />
            <span>{role}</span>
          </label>
        ))}
      </div>
    </fieldset>
  );
}

function stateClass(state) {
  return state.toLowerCase().replace(" ", "-");
}

function Onboarding({ step, onStep, onComplete }) {
  const [exampleIndex, setExampleIndex] = useState(0);
  const example = onboardingExamples[exampleIndex];

  useEffect(() => {
    if (step !== 1) return;
    setExampleIndex(0);
    const interval = window.setInterval(() => setExampleIndex((current) => (current + 1) % onboardingExamples.length), 3900);
    return () => window.clearInterval(interval);
  }, [step]);

  function submitFirstPerson(event) {
    event.preventDefault();
    const data = new FormData(event.currentTarget);
    const name = String(data.get("name") || "My person");
    const person = {
      id: Date.now(),
      name,
      role: String(data.get("role") || "Other"),
      phone: String(data.get("phone") || "+91"),
      language: String(data.get("language") || "Hindi"),
      note: "Added during first setup",
      initials: name.split(" ").map((part) => part[0]).join("").slice(0, 2).toUpperCase(),
    };
    onComplete([person], "Your first person is ready.");
  }

  return (
    <main className="stage">
      <div className="ambient ambient-one" /><div className="ambient ambient-two" />
      <section className="phone-shell onboarding-shell" aria-label="Welcome to Aaraam">
        <div className="status-bar" aria-hidden="true"><span>9:41</span><span className="status-icons">● ◒</span></div>
        <header className="onboarding-top">
          <span className="onboarding-brand"><span className="brand-mark">अ</span><span>Aaraam</span></span>
          <div className="onboarding-progress" aria-label={`Step ${step + 1} of 4`}>{[0, 1, 2, 3].map((item) => <i key={item} className={item === step ? "active" : item < step ? "passed" : ""} />)}</div>
        </header>

        <div className="onboarding-page" key={step}>
          {step === 0 && (
            <>
              <div className="onboarding-visual welcome-visual" aria-hidden="true">
                <span className="welcome-glow" /><span className="welcome-ring ring-a" /><span className="welcome-ring ring-b" /><span className="welcome-ring ring-c" />
                <span className="welcome-speck speck-a" /><span className="welcome-speck speck-b" /><span className="welcome-speck speck-c" />
                <span className="welcome-core">✦</span>
              </div>
              <div className="onboarding-copy">
                <p className="eyebrow">A quieter way to live</p>
                <h1>A little less<br />to carry.</h1>
                <p>The calls, follow-ups and tiny decisions can leave your mind now.</p>
              </div>
              <div className="onboarding-actions"><button className="onboarding-primary" onClick={() => onStep(1)}>Begin</button><small>Private by design. Yours from the start.</small></div>
            </>
          )}

          {step === 1 && (
            <>
              <div className="onboarding-copy centered-copy">
                <p className="eyebrow">One thought in</p>
                <h1>Say it once.<br />Then let it go.</h1>
                <p>Aaraam understands the people, sequence and follow-up—then brings back only what matters.</p>
              </div>
              <div className="onboarding-demo" aria-label="Example request and result">
                <div className="onboarding-example" key={exampleIndex}>
                  <div className="demo-request"><span className="mini-wave"><i /><i /><i /></span><p>{example.request}</p></div>
                  <span className="demo-thread"><i /></span>
                  <div className="demo-result"><span className="person-avatar">{example.initials}</span><div><small>{example.source}</small><strong>{example.result}</strong></div></div>
                </div>
                <div className="example-progress" aria-label={`Example ${exampleIndex + 1} of ${onboardingExamples.length}`}>{onboardingExamples.map((_, index) => <span key={index} className={index === exampleIndex ? "active" : ""}><i /></span>)}</div>
              </div>
              <div className="onboarding-actions split-actions"><button className="onboarding-back" onClick={() => onStep(0)}>Back</button><button className="onboarding-primary" onClick={() => onStep(2)}>Continue</button></div>
            </>
          )}

          {step === 2 && (
            <>
              <div className="onboarding-copy">
                <p className="eyebrow">Nothing to connect</p>
                <h1>No account<br />access. Ever.</h1>
                <p>No contacts, WhatsApp, email or calendar. Aaraam knows only the people you choose to add.</p>
              </div>
              <div className="account-access-visual" aria-label="Aaraam does not connect to your accounts">
                <span className="access-glow" aria-hidden="true" />
                <span className="access-orbit access-orbit-one" aria-hidden="true" />
                <span className="access-orbit access-orbit-two" aria-hidden="true" />
                <div className="access-center"><span>✓</span><strong>Only what<br />you add</strong><small>Nothing else</small></div>
                <span className="access-pill pill-contacts"><strong>Contacts</strong><small>Not connected</small></span>
                <span className="access-pill pill-messages"><strong>WhatsApp</strong><small>Not connected</small></span>
                <span className="access-pill pill-email"><strong>Email</strong><small>Not connected</small></span>
              </div>
              <p className="privacy-footnote"><span>◇</span> No imports · No recordings · No transcripts</p>
              <div className="onboarding-actions split-actions"><button className="onboarding-back" onClick={() => onStep(1)}>Back</button><button className="onboarding-primary" onClick={() => onStep(3)}>Continue without connecting</button></div>
            </>
          )}

          {step === 3 && (
            <form className="onboarding-person" onSubmit={submitFirstPerson}>
              <div className="onboarding-copy">
                <p className="eyebrow">Your trusted circle begins</p>
                <h1>Who helps make<br />life easier?</h1>
                <p>Start with the role you rely on most.</p>
              </div>
              <div className="onboarding-fields">
                <RolePicker autoFocus />
                <label>Name<input name="name" placeholder="Anil ji" required /></label>
                <label>Preferred language<select name="language" defaultValue="Hindi"><option>Hindi</option><option>English</option><option>Hinglish</option><option>Punjabi</option><option>Bengali</option><option>Tamil</option><option>Marathi</option></select></label>
                <label>Phone number<input name="phone" inputMode="tel" placeholder="+91 98765 43210" required /></label>
              </div>
              <div className="onboarding-actions split-actions"><button type="button" className="onboarding-back" onClick={() => onStep(2)}>Back</button><button className="onboarding-primary" type="submit">Meet Aaraam</button></div>
            </form>
          )}

        </div>
        <div className="home-indicator" aria-hidden="true" />
      </section>
    </main>
  );
}

export default function Home() {
  const [screen, setScreen] = useState("home");
  const [phase, setPhase] = useState("idle");
  const [transcript, setTranscript] = useState("");
  const [nodes, setNodes] = useState([]);
  const [result, setResult] = useState("");
  const [detailOpen, setDetailOpen] = useState(false);
  const [composerOpen, setComposerOpen] = useState(false);
  const [people, setPeople] = useState([]);
  const [personSheet, setPersonSheet] = useState(false);
  const [missingName, setMissingName] = useState("");
  const [clarification, setClarification] = useState("");
  const [draft, setDraft] = useState("");
  const [toast, setToast] = useState("");
  const [assistantReply, setAssistantReply] = useState("");
  const [resultSource, setResultSource] = useState("Outcome");
  const [activity, setActivity] = useState(activitySeed);
  const [onboardingStep, setOnboardingStep] = useState(null);
  const timers = useRef([]);

  useEffect(() => {
    const saved = window.localStorage.getItem("aaraam-people");
    if (saved) setPeople(JSON.parse(saved));
    const savedActivity = window.localStorage.getItem("aaraam-activity");
    if (savedActivity) setActivity(JSON.parse(savedActivity));
    const previewOnboarding = new URLSearchParams(window.location.search).get("onboarding") === "1";
    setOnboardingStep(previewOnboarding ? 0 : window.localStorage.getItem("aaraam-onboarded-v1") ? -1 : 0);
    return () => timers.current.forEach(clearTimeout);
  }, []);

  const activeCount = phase === "working" || phase === "planning" ? 1 : 0;
  const activeNode = nodes.find((node) => node.state === "Calling" || node.state === "Preparing");
  const headline = useMemo(() => {
    if (phase === "listening") return "I’m listening";
    if (phase === "planning") return "I understand";
    if (phase === "working") return "You relax.";
    if (phase === "complete") return "Taken care of.";
    return "What can I take care of?";
  }, [phase]);

  function later(fn, delay) {
    const timer = setTimeout(fn, delay);
    timers.current.push(timer);
  }

  function finishTask(message, source, meta) {
    setResult(message);
    setResultSource(source);
    setPhase("complete");
    const newItem = { time: "Just now", title: message, meta };
    setActivity((current) => {
      const updated = [newItem, ...current.filter((item) => item.title !== message)].slice(0, 12);
      window.localStorage.setItem("aaraam-activity", JSON.stringify(updated));
      return updated;
    });
  }

  function resetTask() {
    timers.current.forEach(clearTimeout);
    timers.current = [];
    setPhase("idle");
    setTranscript("");
    setNodes([]);
    setResult("");
    setDetailOpen(false);
    setClarification("");
    setAssistantReply("");
    setResultSource("Outcome");
  }

  function beginVoice() {
    if (phase !== "idle") return;
    setPhase("listening");
    setTranscript("");
    later(() => setTranscript("I’m eating paneer butter masala today…"), 900);
    later(() => setTranscript("I’m eating paneer butter masala today. Check what we need and coordinate dinner for 8."), 1950);
    later(() => runTask("paneer"), 3100);
  }

  function runTask(kind, customText) {
    const text = customText || transcript;
    setComposerOpen(false);
    setClarification("");
    setPhase("planning");
    setAssistantReply("Request understood. Coordinating now.");
    if (customText) setTranscript(customText);

    later(() => {
      if (/rahul|ramesh|unknown/i.test(text)) {
        const match = text.match(/(?:ask|call)\s+([A-Z][a-z]+(?:\s+ji)?)/i);
        setMissingName(match?.[1] || "Rahul");
        setPhase("idle");
        setAssistantReply(`I don’t have ${match?.[1] || "Rahul"} in My People yet.`);
        setPersonSheet(true);
        return;
      }
      if (/maintenance|electrician/i.test(text) && !/(today|tomorrow|sunday|monday|morning|afternoon|evening|\d)/i.test(text)) {
        setClarification("When should the electrician come?");
        setPhase("idle");
        setAssistantReply("When should the electrician come?");
        return;
      }

      setPhase("working");
      if (kind === "driver" || /anil|driver|gate/i.test(text)) {
        setNodes([{ id: "anil", person: "Anil ji", action: "Come to the main gate", state: "Calling" }]);
        later(() => setNodes([{ id: "anil", person: "Anil ji", action: "Meet at Gate 2", state: "Done" }]), 2200);
        later(() => {
          const finalReply = "Anil ji will meet you at Gate 2.";
          finishTask(finalReply, "Response from Anil ji", "1 call · 38 sec");
        }, 3000);
        return;
      }

      if (kind === "shanti" || /shanti/i.test(text)) {
        setNodes([{ id: "shanti", person: "Shanti", action: "Ask when she’ll come", state: "Calling" }]);
        later(() => setNodes([{ id: "shanti", person: "Shanti", action: "Coming around 6 pm", state: "Done" }]), 2600);
        later(() => finishTask("Shanti says she’ll come at 6 pm.", "Response from Shanti", "1 call · 42 sec"), 3400);
        return;
      }

      if (kind === "paneer" || /paneer|dinner|cook/i.test(text)) {
        setNodes(paneerNodes);
        later(() => setNodes([
          { ...paneerNodes[0], state: "Done", action: "Paneer, tomatoes & butter needed" },
          { ...paneerNodes[1], state: "Calling" }, paneerNodes[2], paneerNodes[3],
        ]), 1800);
        later(() => setNodes([
          { ...paneerNodes[0], state: "Done", action: "Pantry checked" },
          { ...paneerNodes[1], state: "Done", action: "Delivery by 6:15 pm" },
          { ...paneerNodes[2], state: "Calling" },
          { ...paneerNodes[3], state: "Preparing" },
        ]), 3900);
        later(() => setNodes([
          { ...paneerNodes[0], state: "Done", action: "Pantry checked" },
          { ...paneerNodes[1], state: "Done", action: "Delivery by 6:15 pm" },
          { ...paneerNodes[2], state: "Done", action: "Dinner ready by 8 pm" },
          { ...paneerNodes[3], state: "Calling" },
        ]), 5900);
        later(() => {
          setNodes(paneerNodes.map((node) => ({ ...node, state: "Done" })));
          const finalReply = "Dinner coordinated for 8 pm.";
          finishTask(finalReply, "Household outcome", "4 calls · 7 min");
        }, 7600);
        return;
      }

      setNodes([{ id: "task", person: "Assistant", action: "Coordinating your request", state: "Calling" }]);
      later(() => {
        setNodes([{ id: "task", person: "Assistant", action: "Request completed", state: "Done" }]);
        const finalReply = "The person confirmed your request.";
        finishTask(finalReply, "Outcome", "1 completed request");
      }, 2800);
    }, 650);
  }

  function submitText(event) {
    event.preventDefault();
    if (!draft.trim()) return;
    const lowered = draft.toLowerCase();
    const kind = /anil|driver|gate/.test(lowered) ? "driver" : /shanti/.test(lowered) ? "shanti" : /paneer|dinner|cook/.test(lowered) ? "paneer" : "generic";
    runTask(kind, draft.trim());
    setDraft("");
  }

  function savePerson(event) {
    event.preventDefault();
    const data = new FormData(event.currentTarget);
    const name = String(data.get("name") || missingName || "New person");
    const person = {
      id: Date.now(), name, role: String(data.get("role") || "Other"),
      phone: String(data.get("phone") || "+91"), language: String(data.get("language") || "Hindi"),
      note: String(data.get("note") || ""), initials: name.split(" ").map((part) => part[0]).join("").slice(0, 2).toUpperCase(),
    };
    const updated = [...people, person];
    setPeople(updated);
    window.localStorage.setItem("aaraam-people", JSON.stringify(updated));
    setPersonSheet(false);
    setMissingName("");
    setToast(`${name} added to My People`);
    later(() => setToast(""), 2600);
  }

  function completeOnboarding(newPeople, outcome) {
    const updated = newPeople.reduce((current, person) => {
      const exists = current.some((item) => item.name.toLowerCase() === person.name.toLowerCase());
      return exists ? current : [...current, person];
    }, people);
    setPeople(updated);
    window.localStorage.setItem("aaraam-people", JSON.stringify(updated));
    const firstActivity = { time: "Just now", title: outcome, meta: "First request" };
    setActivity((current) => {
      const next = [firstActivity, ...current.filter((item) => item.title !== outcome)].slice(0, 12);
      window.localStorage.setItem("aaraam-activity", JSON.stringify(next));
      return next;
    });
    window.localStorage.setItem("aaraam-onboarded-v1", "true");
    setOnboardingStep(-1);
    setToast("Welcome to Aaraam.");
    later(() => setToast(""), 3200);
  }

  if (onboardingStep === null) {
    return <main className="stage"><section className="phone-shell launch-splash"><span className="brand-mark">अ</span><p>Aaraam</p></section></main>;
  }

  if (onboardingStep >= 0) {
    return <Onboarding step={onboardingStep} onStep={setOnboardingStep} onComplete={completeOnboarding} />;
  }

  return (
    <main className="stage">
      <div className="ambient ambient-one" />
      <div className="ambient ambient-two" />
      <section className="phone-shell" aria-label="Aaraam personal assistant">
        <div className="status-bar" aria-hidden="true"><span>9:41</span><span className="status-icons">● ◒</span></div>

        <header className="topbar">
          <button className="brand" onClick={() => { setScreen("home"); resetTask(); }} aria-label="Aaraam home">
            <span className="brand-mark">अ</span><span>Aaraam</span>
          </button>
          <button className="people-button" onClick={() => setScreen("people")} aria-label="Open My People">
            <span className="avatar-stack" aria-hidden="true">
              {people.slice(0, 2).map((person) => <span key={person.id}>{person.initials}</span>)}
              {people.length > 2 && <span>+{people.length - 2}</span>}
            </span>
          </button>
        </header>

        {screen === "home" && (
          <div className={`home-view phase-${phase}`}>
            <div className="hero-copy">
              <p className="eyebrow">{activeCount ? "1 chore in motion" : "Your time is yours"}</p>
              <h1>{headline}</h1>
              <p className="subline">
                {phase === "idle" && !clarification && "Say it once. I’ll handle the calls."}
                {phase === "listening" && (transcript || "Go ahead…")}
                {phase === "planning" && "Turning that into a simple plan."}
                {phase === "working" && "Everything is moving into place."}
                {phase === "complete" && "Here’s what came back."}
                {clarification && clarification}
              </p>
            </div>

            {(phase === "working" || phase === "planning" || phase === "complete") && (
              <div className="execution" aria-live="polite">
                {phase === "complete" ? (
                  <div className="result-card">
                    <div className="result-source"><span className="result-avatar">{resultSource.includes("Shanti") ? "SH" : resultSource.includes("Anil") ? "AJ" : "✓"}</span><span><small>{resultSource}</small><time>Just now</time></span></div>
                    <h2>{result}</h2>
                    <p>Only this useful outcome is saved.</p>
                  </div>
                ) : (
                  <>
                    <div className="assistant-response">
                      <span className="response-mark" aria-hidden="true"><i /><i /><i /></span>
                      <span>{assistantReply}</span>
                    </div>
                    <div className="intelligence-field" aria-hidden="true">
                      <span className="field-glow" />
                      <span className="signal-halo halo-one" />
                      <span className="signal-halo halo-two" />
                      <span className="signal-halo halo-three" />
                      <span className="orbiting-signal signal-one" />
                      <span className="orbiting-signal signal-two" />
                      <span className="orbiting-signal signal-three" />
                      <span className="constellation-point point-one" />
                      <span className="constellation-point point-two" />
                      <span className="constellation-point point-three" />
                      <span className="constellation-point point-four" />
                      <div className="source-node"><span className="pulse-core">✦</span></div>
                    </div>
                    <div className="intelligence-status">
                      <span className="status-signal" />
                      {phase === "planning" && "Understanding your request"}
                      {phase === "working" && (activeNode ? `Coordinating with ${activeNode.person}` : "Coordinating quietly")}
                    </div>
                    <div className="network-line" aria-hidden="true"><span /></div>
                  </>
                )}
                <div className="task-nodes">
                  {phase === "planning" && <div className="plan-reading"><span className="tiny-spinner" /> Finding the calmest path</div>}
                  {nodes.map((node, index) => (
                    <button className={`task-node ${stateClass(node.state)}`} key={node.id} onClick={() => setDetailOpen(true)} style={{ animationDelay: `${index * 90}ms` }}>
                      <span className="node-dot">{node.state === "Done" ? "✓" : index + 1}</span>
                      <span className="node-copy"><strong>{node.person}</strong><small>{node.action}</small></span>
                      <span className="node-state">{node.state}</span>
                    </button>
                  ))}
                </div>
              </div>
            )}

            {clarification && (
              <div className="clarify-card">
                <div className="clarify-input"><span>Sunday afternoon</span><button onClick={() => runTask("generic", "Call maintenance for an electrician on Sunday afternoon")}>Send</button></div>
                <p>I’ll only ask when one detail is truly needed.</p>
              </div>
            )}

            {phase === "idle" && !clarification && (
              <div className="voice-zone">
                <button className="mic-button" onClick={beginVoice} aria-label="Tap to speak">
                  <span className="mic-icon" aria-hidden="true"><i /></span>
                  <span className="orbit orbit-one" /><span className="orbit orbit-two" />
                </button>
                <p>Tap to speak</p>
                <button className="type-link" onClick={() => setComposerOpen(true)}>or type instead</button>
              </div>
            )}

            {phase === "listening" && (
              <div className="listening-zone" aria-label="Listening">
                <div className="waveform" aria-hidden="true">{Array.from({ length: 22 }).map((_, i) => <i key={i} style={{ animationDelay: `${i * -55}ms` }} />)}</div>
                <button className="finish-speaking" onClick={() => runTask("paneer")}>Done speaking</button>
              </div>
            )}

            {phase === "complete" && (
              <div className="complete-actions">
                <button onClick={() => setDetailOpen(!detailOpen)}>{detailOpen ? "Hide details" : "See details"}</button>
                <button className="primary-small" onClick={resetTask}>Done</button>
              </div>
            )}

            {detailOpen && phase === "complete" && (
              <div className="detail-panel">
                <div><span>Calls placed</span><strong>{nodes.length}</strong></div>
                <div><span>Completed</span><strong>Just now</strong></div>
                <p>Only this short outcome is saved. Audio and transcripts are discarded.</p>
              </div>
            )}
          </div>
        )}

        {screen === "people" && (
          <div className="subscreen people-screen">
            <div className="screen-heading"><button className="back" onClick={() => setScreen("home")} aria-label="Back">‹</button><div><p className="eyebrow">Your trusted circle</p><h1>My People</h1></div><button className="add" onClick={() => setPersonSheet(true)} aria-label="Add person">＋</button></div>
            <p className="privacy-note"><span>◇</span> Added manually. Your contacts stay untouched.</p>
            <div className="people-list">
              {people.map((person) => <button className="person-row" key={person.id} onClick={() => setToast(`${person.name} · ${person.language}`)}>
                <span className="person-avatar">{person.initials}</span>
                <span className="person-copy"><strong>{person.name}</strong><small>{person.role} · {person.language}</small></span>
                <span className="chevron">›</span>
              </button>)}
            </div>
            <button className="activity-link" onClick={() => setScreen("activity")}><span>⌁</span><span><strong>Activity</strong><small>Minimal outcomes, nothing more</small></span><span>›</span></button>
          </div>
        )}

        {screen === "activity" && (
          <div className="subscreen activity-screen">
            <div className="screen-heading"><button className="back" onClick={() => setScreen("people")} aria-label="Back">‹</button><div><p className="eyebrow">Quiet history</p><h1>Activity</h1></div></div>
            <div className="activity-list">{activity.map((item, index) => <article className="activity-row" key={`${item.time}-${item.title}-${index}`}><span className="activity-check">✓</span><div><time>{item.time}</time><h2>{item.title}</h2><p>{item.meta}</p></div></article>)}</div>
            <p className="retention-copy">No recordings. No transcripts. Just enough to remember what was handled.</p>
          </div>
        )}

        {composerOpen && (
          <div className="sheet-backdrop" onClick={() => setComposerOpen(false)}>
            <form className="bottom-sheet composer" onSubmit={submitText} onClick={(e) => e.stopPropagation()}>
              <span className="sheet-handle" /><label htmlFor="instruction">What can I take care of?</label>
              <textarea id="instruction" autoFocus value={draft} onChange={(e) => setDraft(e.target.value)} placeholder="Ask Anil ji to meet me at the main gate in 5 minutes…" />
              <div className="sheet-actions"><button type="button" onClick={() => setComposerOpen(false)}>Cancel</button><button className="sheet-primary" type="submit">Take care of it</button></div>
            </form>
          </div>
        )}

        {personSheet && (
          <div className="sheet-backdrop" onClick={() => setPersonSheet(false)}>
            <form className="bottom-sheet person-form" onSubmit={savePerson} onClick={(e) => e.stopPropagation()}>
              <span className="sheet-handle" /><p className="eyebrow">Not in My People</p><h2>Add {missingName || "someone"}</h2><p className="form-intro">Add them once, then Aaraam can handle future calls.</p>
              <RolePicker autoFocus />
              <label>Name<input name="name" defaultValue={missingName} required /></label>
              <label>Preferred language<select name="language" defaultValue="Hindi"><option>Hindi</option><option>English</option><option>Hinglish</option><option>Punjabi</option><option>Bengali</option><option>Tamil</option><option>Marathi</option></select></label>
              <label>Phone number<input name="phone" inputMode="tel" placeholder="+91 98765 43210" required /></label>
              <label>Optional note<input name="note" placeholder="Usual hours, pronunciation…" /></label>
              <div className="sheet-actions"><button type="button" onClick={() => setPersonSheet(false)}>Cancel</button><button className="sheet-primary" type="submit">Add to My People</button></div>
            </form>
          </div>
        )}

        {toast && <div className="toast" role="status">{toast}</div>}
        <div className="home-indicator" aria-hidden="true" />
      </section>
    </main>
  );
}
